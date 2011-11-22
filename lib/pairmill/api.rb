require 'yaml'

module Pairmill
  module Api
    def create_session(session)
      post("/v1/sessions", {
        :body => {
          :session => {
            :name         => session.name,
            :viewers      => session.viewers,
            :participants => session.participants,
            :tunnel       => {
              :host_login => session.host_login
            }
          }
        }
      })
    end

    def join_session(session)
      options = { :query => { :name => session.name, :host => session.host, :format => "json" } }
      get("/v1/sessions/search.json", options)
    end

    def api_token
      config[:api_token]
    end

    def config
      @config ||= if File.exists?(config_file)
        YAML.load_file(config_file)[base_uri] || setup_config
      else
        setup_config
      end
    end

    def config_file
      File.expand_path("~/.pairmill.yml")
    end

    def setup_config
      config = YAML.load_file(config_file) rescue {}

      print "Please input your API token for #{base_uri}: "
      config[base_uri] = {:api_token => $stdin.gets.chomp}

      File.open(config_file, 'w') do |f|
        f.write(YAML.dump(config))
      end

      config[base_uri]
    end

    include HTTParty
    extend self

    base_uri ENV['BASE_URI'] || 'api.pairmill.com'
    default_params :api_token => api_token
  end
end
