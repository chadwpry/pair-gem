require "pair/notification/custom_errors"
require "pair/notification/dispatcher"
require "pair/notification/o_s_x_dispatcher"
require "pair/notification/linux_dispatcher"

module Pair
  class Notification
    attr_reader :dispatch

    class << self
      def dispatcher(options = {})
        if Pair::OS.os_x?
          dispatch = OSXDispatcher.new(options)
        else
          dispatch = LinuxDispatcher.new(options)
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

