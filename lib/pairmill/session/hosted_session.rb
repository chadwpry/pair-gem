module Pairmill
  class Session
    class HostedSession < self
      attr_accessor :tunnel,  :authorized_keys_file,  :tmux,  :response
      private       :tunnel=, :authorized_keys_file=, :tmux=, :response=

      def initialize(options = {})
        puts "Hosting session #{"called #{options[:name].inspect} " if options[:name]}..."

        self.name         = options.delete(:name)
        self.viewers      = options.delete(:viewers)      || []
        self.participants = options.delete(:participants) || []
        self.tmux         = Tmux.new(self)

        super(options)
      end

      def start!
        if setup
          display_startup_message

          tunnel.open do
            tmux.start
            tmux.attach
          end
        else
          puts "There was a problem starting the host session %s" % (name && name.inspect)
          puts "response: #{response.inspect}" if response && $-d
          puts ""
        end

        exit
      end

      def display_startup_message
        puts "Your pairs can connect to this session using the following command:"
        puts ""
        puts "	#{connect_command}"
        puts ""
        print "Press any key to continue..."

        gets
      end

      # TODO: this should get host/user from response
      def connect_command
        "ssh-add; ssh -tqA -l#{bastion["join_user"]} #{bastion["host"]} #{name}"
      end

      def bastion
        response["tunnel"]["bastion"]
      end

      def host_login
        `whoami`.chomp
      end

      def cleanup_authorized_keys
        authorized_keys_file.cleanup
      end

      private

      def setup
        create_session_on_server && authorized_keys_file.install
      end

      def create_session_on_server
        self.response = Api.create_session(self)["session"]

        if self.response
          self.name                 = response["name"]
          self.tunnel               = Tunnel.new(self.response["tunnel"].merge(:host => true))
          self.authorized_keys_file = AuthorizedKeysFile.new(self.response["member_keys"], self)
        end
      end

      def stop!
        tunnel.close
        tmux.stop
        cleanup_authorized_keys
      end
    end

    def self.host(options)
      HostedSession.new(options).start!
    end
  end
end

