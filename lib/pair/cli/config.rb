module Pair
  class Cli
    class Config < self
      def run!
        parse!

        Pair.config(options)
      end

      def parse!
        opts = parse do |opts|
          opts.banner = "Usage: #{$0.split("/").last} config" +
                        "\n\n" +
                        "Options:" +
                        "\n"

          opts.on("-t", "--api-token KEY") do |key|
            options[:api_token] = key
          end

          opts.on("-g", "--growl") do
            options[:growl] = true
          end
        end
      end
    end
  end
end
