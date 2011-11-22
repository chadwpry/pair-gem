require 'fileutils'

module Pairmill
  class Session
    class Tmux
      TMP_PATH = "/tmp"

      attr_accessor :session
      private       :session=

      def initialize(session)
        self.session = session
        create_socket_directory
      end

      def app_path
        self.class.to_s.split('::').first.downcase
      end

      def unique
        @unique ||= srand.to_s[0,5]
      end

      def start
        args = %W[-S #{socket_path} new-session -d]
        system "tmux", *args

        at_exit { stop }
      end

      def stop
        `lsof -t #{socket_path}/ | xargs kill -9`
        FileUtils.rm_f(socket_path)
        self.session.cleanup_authorized_keys if self.session.respond_to?(:cleanup_authorized_keys)
      end

      # correct this method to use the remote user instead of chad
      def window(command)
        args = %W[-S #{socket_path} new-window -t #{session.name}:0 -n 'Pairing', 'ssh pair@bastion.pairmill.com -l chad -A']
        system "tmux", *args
      end

      def attach(read_only = false)
        args = %W[-S #{socket_path} attach]
        args += " -r" if read_only

        system "tmux", *args
      end

      private
      def create_socket_directory
        FileUtils.mkdir_p(socket_directory, :mode => 0700)
      end

      def socket_directory
        File.join TMP_PATH, app_path
      end

      def socket_path
        File.join socket_directory, socket_name
      end

      def socket_name
        "tmux-#{session.name}"#-#{unique}"
      end
    end
  end
end
