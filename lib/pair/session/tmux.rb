require 'fileutils'
require 'tmpdir'

module Pair
  class Session
    class Tmux
      attr_accessor :session_name
      private       :session_name=

      def initialize(session_name)
        self.session_name = session_name
      end

      def start
        args = %W[-S #{socket_path} new-session -d]
        system tmux, *args
      end

      def attach(read_only = false)
        system(*attach_command(read_only))
      end

      def stop
        `lsof -t #{socket_path}/ 2>/dev/null | xargs kill -9`
        FileUtils.rm_f(socket_path)
      end

      def attach_command(read_only = false)
        args = %W[#{tmux} -S #{socket_path} attach]
        args << " -r" if read_only
        args
      end

      private

      def tmux
        @tmux ||= `which tmux`.chomp
      end

      def socket_path
        File.join(Dir.tmpdir, socket_name)
      end

      def socket_name
        "pair-#{session_name.gsub(/[^\w_-]+/,'')}.tmux"
      end
    end
  end
end
