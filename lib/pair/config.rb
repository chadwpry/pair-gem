require 'yaml/store'

module Pair
  HOST = ENV['HOST'] || "api.pairmill.com"

  def self.config(options = nil)
    config = Config.new(HOST, STDIN, STDOUT)
    config.update(options) if options
    config
  end

  class Config
    attr_accessor :host, :input, :output

    def initialize(host = HOST, input = STDIN, output = STDOUT)
      self.host   = host
      self.input  = input
      self.output = output
    end

    def method_missing(method, *args, &block)
      method = method.to_s

      if method =~ /=$/ # setter
        self[method.gsub(/=$/,'').to_sym] = [*args].first
      else
        self[method.to_sym] || super
      end
    end

    def api_token
      self[:api_token]
    end

    def enable_ssh
      self[:enable_ssh]
    end

    def growl_enabled?
      self[:growl_enabled]
    end

    def ssh_enabled?
      if Pair::OS.os_x?
        `systemsetup -getremotelogin`.match("Remote Login: On")
      elsif Pair::OS.linux?
        `ps aux | grep sshd | grep -v grep` != ""
      end
    end

    def update(options = {})
      if options.is_a? Hash
        options.each do |k,v|
          config.transaction do
            host_config[k] = v
          end
        end
      end
    end

    protected
    def [](key)
      config.transaction do
        host_config[key]
      end
    end

    def []=(key, value)
      config.transaction do
        host_config[key] = value
      end
    end

    # Must be called within a config transaction
    def host_config
      config[host] ||= {}
    end

    def config
      @config ||= YAML::Store.new(config_file)
    end

    def config_file
      File.join(ENV['HOME'], ".pair.yml")
    end

    def print(*args)
      output.print(*args)
    end

    def gets(*args)
      input.gets(*args)
    end
  end
end
