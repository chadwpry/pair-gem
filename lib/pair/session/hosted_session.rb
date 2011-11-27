module Pair
  class Session
    def self.host(options)
      session = HostedSession.new(options)
      at_exit { session.stop! }

      session.start!
      session.stop!
    end

    class HostedSession < self
      attr_accessor :tunnel,  :authorized_keys_file,  :response
      private       :tunnel=, :authorized_keys_file=, :response=

      def initialize(options = {})
        puts "Hosting session #{"called #{options[:name].inspect} " if options[:name]}..."

        self.name         = options.delete(:name)
        self.viewers      = options.delete(:viewers)      || []
        self.participants = options.delete(:participants) || []

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
          connection_error!
        end

        exit
      end

      def stop!
        tmux.stop
        tunnel.close
        cleanup_authorized_keys
      rescue
        raise if $-d
      end

      def host_login
        `whoami`.chomp
      end

      private

      def tmux
        @tmux ||= Tmux.new(name)
      end

      def tunnel
        @tunnel ||= Tunnel.new(response["tunnel"])
      end

      def authorized_keys_file
        @key_file ||= AuthorizedKeysFile.new(response["member_keys"], tmux.method(:attach_command))
      end

      def display_startup_message
        puts "Your pairs can connect to this session using the following command:"
        puts ""
        puts "	#{connect_command}"
        puts ""
        print "Press [Enter] to continue..."

        gets
      end

      def connect_command
        "ssh-add; ssh -tqA -l#{bastion["join_user"]} #{bastion["host"]} #{name}"
      end

      def bastion
        response["tunnel"]["bastion"]
      end

      def cleanup_authorized_keys
        authorized_keys_file.cleanup
      end

      def setup
        create_session_on_server && authorized_keys_file.install
      end

      def create_session_on_server
        self.response = Api.create_session(self)["session"]
        if response
          self.name = response['name']
          true
        else
          false
        end
      end

      def connection_error!
        puts "There was a problem starting the host session %s" % (name && name.inspect)
        puts "response: #{response.inspect}" if response && $-d
        puts ""
        abort
      end
    end
  end
end

