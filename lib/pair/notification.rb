module Pair
  class Notification
    attr_reader :dispatch

    class << self
      def dispatcher(options = {})
        if Pair::OS.os_x?
          dispatch = OSXDispatcher.new(options)
        else
          raise NotImplementedError
        end

        if block_given?
          yield dispatch
        else
          dispatch
        end
      end
    end
  end
end

require "pair/notification/custom_errors"
require "pair/notification/dispatcher"
require "pair/notification/o_s_x_dispatcher"

