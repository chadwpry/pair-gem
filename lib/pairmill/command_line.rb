require "pairmill"
require "optparse"

module Pairmill
  class CommandLine
    attr_accessor :arguments,  :options
    private       :arguments=, :options=

    def self.run!(*arguments)
      new(*arguments).run!
    end

    def initialize(arguments)
      self.arguments = arguments
      self.options   = {}
    end

    def run!
      case command = arguments.shift
      # when 'join'
        # require "pairmill/command_line/join"
        # Join.run!(arguments)
      when 'host'
        require "pairmill/command_line/host"
        Host.run!(arguments)
      else
        unknown_command(command)
      end
    rescue SystemExit
      raise
    rescue
      if $-d
        STDOUT.puts "\n"
        STDOUT.puts "  Please contact support@pairmill.com, there"
        STDOUT.puts "  was an issue creating your session."
        STDOUT.puts "\n"
      else
        raise
      end
    end

    private
    def unknown_command(command)
      puts "Unknown command: #{command}" if command

      #{$0} join [options]
      abort %Q[
        Usage: #{$0} host [options]

        You can pass -h to a subcommand to learn more about it.

          e.g. #{$0} join -h
      ].gsub(/^ {0,9}/,'')
    end

    def parse
      opts = OptionParser.new { |o| yield(o) }
      opts.parse!(arguments)
      opts
    end
  end
end

