module Pair
  class Notification
    class Dispatcher
      attr_accessor :logger, :enabled

      def initialize(options = {})
        @enabled = Pair.config.growl_enabled?
        @logger = options[:logger] || STDOUT
      end

      def session_join(user, session)
        raise NotImplementedError
      end

      def session_part(user, session)
        raise NotImplementedError
      end

      def gntp_notify
        raise NotImplementedError
      end
    end
  end
end
