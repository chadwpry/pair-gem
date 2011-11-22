require "pairmill/command_line"

module Pairmill
  class CommandLine
    class Join < self
      def run!
        parse!
        Pairmill::Session.join(options)
      end

      def parse!
        opts = parse do |opts|
          opts.banner = "Usage: #{$0} join HOST SESSION_NAME" +
                        "\n\n" +
                        "HOST is the email address of the user who started the session. The SESSION_NAME should be given to you by the host." +
                        "\n\n"+
                        "Options:"

          opts.on_tail("-h", "--help", "Display this text") do
            puts opts
            exit
          end
        end

        host, session = *arguments

        if host.nil? || session.nil?
          $stderr.puts "ERROR: Both HOST and SESSION_NAME must be provided to join a session.\n\n"
          abort(opts.inspect)
        else
          options[:host]    = host
          options[:session] = session
        end
      end
    end
  end
end

