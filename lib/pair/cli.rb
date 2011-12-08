require "pair"
require 'pair/cli/custom_errors'
require "optparse"

module Pair
  class Cli
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
      when 'host'
        require "pair/cli/host"
        Host.run!(arguments)
      when 'config'
        require "pair/cli/config"
        Config.run!(arguments)
      else
        unknown_command(command)
      end
    rescue ApiTokenMissingError, EnableSSHError => error
      handle_error error.message, false
    rescue SystemExit
      raise
    rescue
      handle_error "  Please contact support@pairmill.com, there\n" +
                   "  was an issue creating your session.", $-d
    end

    private
    def handle_error message, reraise = true
      if reraise
        raise
      else
        STDOUT.puts "\n"
        STDOUT.puts message
        STDOUT.puts "\n"
      end
    end

    def unknown_command(command)
      puts "Unknown command: #{command}" if command

      #{$0} join [options]
      abort %Q[
        Usage: #{$0.split("/").last} host [options]

        You can pass -h to a subcommand to learn more about it.

          e.g. #{$0.split("/").last} join -h
      ].gsub(/^ {0,9}/,'')
    end

    def parse
      opts = OptionParser.new { |o| yield(o) }
      opts.parse!(arguments)
      opts
    end
  end
end

