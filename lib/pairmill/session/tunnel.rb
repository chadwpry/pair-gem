module Pairmill
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
        self.tunnel = IO.popen(ssh_command)
        puts "SSH tunnel started (PID = #{tunnel.pid})" if $-d
        at_exit { close }
        yield if block_given?
      end

      def close
        @tunnel_closed ||= begin
          puts "Closing connection..."
          Process.kill("INT", tunnel.pid)
          Process.wait
          true
        end
      end

      private

      def ssh_command
        options = []
        if self.options[:host]
          options << "-nq"
          options << "-l #{bastion["host_user"]}"
          options << "-p #{bastion["ssh_port"]}" unless bastion["ssh_port"] == 22
          options << "-R #{port}:localhost:#{host_port}"
        else
          options << "-tAq"
          options << "-l #{bastion["join_user"]}"
        end

        "ssh #{bastion["host"]} #{options.join(" ")}"
      end

      def method_missing(method, *args, &block)
        options[method.to_s] || super(method, *args, &block)
      end
    end
  end
end
