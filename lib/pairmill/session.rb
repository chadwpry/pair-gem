require "pairmill/session/tmux"
require "pairmill/session/tunnel"
require "pairmill/session/authorized_keys_file"
require "pairmill/session/hosted_session"
require "pairmill/session/joined_session"

module Pairmill
  class Session
    attr_accessor :host,  :name,  :options,  :viewers,  :participants
    private       :host=, :name=, :options=, :viewers=, :participants=

    def initialize(options = {})
      self.options = options
    end
  end
end
