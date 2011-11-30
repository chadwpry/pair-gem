require 'yaml/store'

module Pair
  def self.config
    host = ENV['HOST'] || "api.pairmill.com"
    Config.new(host, STDIN, STDOUT)
  end

  class Config
    attr_accessor :host, :input, :output

    def initialize(host, input = STDIN, output = STDOUT)
      self.host   = host
      self.input  = input
      self.output = output
    end

    def api_token
      self[:api_token] ||= begin
        print "Please input your API token for Pair: "
        gets.chomp
      end
    end

    def method_missing(method, *args, &block)
      method = method.to_s

      if method =~ /=$/ # setter
        self[method.gsub(/=$/,'').to_sym] = [*args].first
      else
        self[method.to_sym] || super
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
