module Pairmill
  class Session
    class JoinedSession < self
      attr_accessor :response,  :tunnel,  :tmux
      private       :response=, :tunnel=, :tmux=

      def initialize(host, name, options = {})
        puts "Joining session..."

        self.host    = host
        self.name    = name
        self.tmux    = Tmux.new(self)

        super(options)
      end

      def host_login
        `whoami`.chomp
      end

      def start!
        fetch_session_details
        self
      end

      private

      def fetch_session_details
        puts "Fetching session details"

        self.response = Api.join_session(self)["session"]
        self.tunnel   = Tunnel.new(self.response["tunnel"])

        connect!
      end

      def connect!
        tunnel.open do
          tmux.start
          tmux.attach
        end
      end
    end

    def self.join(options)
      JoinedSession.new(
        options.delete(:host),
        options.delete(:session),
        options
      ).start!
    end
  end
end

