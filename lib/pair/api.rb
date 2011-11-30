require 'httparty'
require 'pair/config'

module Pair
  module Api
    include HTTParty
    extend self

    base_uri ENV['BASE_URI'] || 'api.pairmill.com'
    default_params :api_token => Pair.config.api_token

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
  end
end
