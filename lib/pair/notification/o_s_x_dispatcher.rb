require 'ruby_gntp'

module Pair
  class Notification
    class OSXDispatcher < Dispatcher
      attr_reader :growl, :app_icon

      NOTIFICATIONS = [{:name => "Session Events", :enabled => true}]

      def initialize(options = {})
        @app_icon = options.delete(:app_icon)
        super

        register_growl if Pair.config.growl_enabled?

      rescue Errno::ECONNREFUSED => except
        raise Pair::Notification::GNTPError.new("Growl notification transfer protocol is not enabled, either start growl or disable growl via pair config")
      end

      def register_growl
        @growl = GNTP.new(Pair::APPLICATION_NAME)
        @growl.register application_hash
      end

      def session_join(user, session)
        gntp_notify({
          :name => "Session Events", :title => "Pair Message",
          :text => "#{user} joined session \"#{session}\"",
          :icon => Pair::ICON_SESSION_JOIN, :sticky => true
        })
      end
      
      def session_part(user, session)
        gntp_notify({
          :name => "Session Events", :title => "Pair Message",
          :text => "#{user} parted session \"#{session}\"",
          :icon => Pair::ICON_SESSION_JOIN, :sticky => true
        })
      end


      def gntp_notify(options)
        if enabled
          if block_given?
            yield @growl
          end

          if options[:text]
            options = {
              :name => "Session Events", :title => "",
              :icon => @app_icon, :sticky => false
            }.merge(options)

            @growl.notify(options)
          end
        end
      end

      private

      def application_hash
        { :app_icon => Pair::ICON_APPLICATION, :notifications => NOTIFICATIONS }
      end
    end
  end
end
