require 'httparty'
require 'pair/config'

module Pair
  module Api
    include HTTParty
    extend self

    def setup
      base_uri Pair.config.host
      default_params :api_token => Pair.config.api_token
      yield
    end

    def create_session(session)
      setup do
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
    end

    def join_session(session)
      setup do
        options = { :query => { :name => session.name, :host => session.host, :format => "json" } }
        get("/v1/sessions/search.json", options)
      end
    end
  end
end
