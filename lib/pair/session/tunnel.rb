require 'net/ssh'

module Pair
  class Session
    class Tunnel
      attr_accessor :options,  :tunnel
      private       :options=, :tunnel=

      # E.g. options:
      # {
      #   "host_port"  => 22,
      #   "host_login" => "bjeanes",
      #   "port"       => 2222,
      #   "bastion" => {
      #     "host"       => "bastion.pairmill.com",
      #     "ip_address" => "12.12.12.12",
      #     "ssh_port"   => 22,
      #     "host_user"  => "host",
      #     "join_user"  => "join",
      #   }
      # }
      def initialize(options)
        self.options = options
      end

      def open
        Net::SSH.start(ssh_host, ssh_user, :port => ssh_port) do |ssh|
          self.tunnel = ssh

          # Set up actual port tunnels
          ssh.forward.remote(tunnel_local_port, "localhost", tunnel_remote_port)

          # Block until ports have been forwarded
          ssh.loop { ssh.forward.active_remotes.empty? }
          @thread = Thread.new { ssh.loop { ssh.closed? } }
        end

        if block_given?
          yield
          close
        end
      end

      def close
        @tunnel_closed ||= begin
          puts "Closing connection..."

          tunnel.close
          @thread.join

          true
        end
      end

      private

      def bastion
        options["bastion"]
      end

      def ssh_host
        bastion["host"]
      end

      def ssh_user
        bastion["host_user"]
      end

      def ssh_port
        bastion["ssh_port"] || 22
      end

      def tunnel_remote_port
        options["port"]
      end

      def tunnel_local_port
        options["host_port"]
      end

      # def ssh_command
        # options = []

        # options << "-nqT" # Run no command, be quiet, don't allocate pseudo-terminal
        # options << "-l #{bastion["host_user"]}"
        # options << "-p #{bastion["ssh_port"]}" unless bastion["ssh_port"] == 22
        # options << "-R #{port}:localhost:#{host_port}"

        # "ssh #{bastion["host"]} #{options.join(" ")}"
      # end
    end
  end
end
