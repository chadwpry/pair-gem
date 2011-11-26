require "pair/session/tmux"
require "pair/session/tunnel"
require "pair/session/authorized_keys_file"
require "pair/session/hosted_session"

module Pair
  class Session
    attr_accessor :host,  :name,  :options,  :viewers,  :participants
    private       :host=, :name=, :options=, :viewers=, :participants=

    def initialize(options = {})
      self.options = options
    end
  end
end
