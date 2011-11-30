require 'yaml/store'

module Pair
  def self.config
    Config.new(STDIN, STDOUT)
  end

  class Config < Struct.new(:in, :out)
    def api_token
      self[:api_token] ||= begin
        print "Please input your API token for Pair: "
        gets.chomp
      end
    end

    protected

    def [](key)
      config.transaction do
        config[key]
      end
    end

    def []=(key, value)
      config.transaction do
        config[key] = value
      end
    end

    def config
      @config ||= YAML::Store.new(config_file)
    end

    def config_file
      File.join(ENV['HOME'], ".pair.yml")
    end

    def print(*args)
      self.out.print(*args)
    end

    def gets(*args)
      self.in.gets(*args)
    end
  end
end
