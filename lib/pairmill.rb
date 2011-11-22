require 'ruby-debug' if ENV["DEBUGGER"] == "true"
require 'httparty'
require "pairmill/api"
require "pairmill/session"

module Pairmill
  VERSION = "0.0.1"
end
