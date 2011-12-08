module Pair
  class Cli
    class Config < self
      def run!
        parse!
        Pair.config(options)
      end

      def parse!
        opts = parse do |opts|
          opts.banner = "Usage: #{$0} config" +
                        "\n\n" +
                        "Options:" +
                        "\n"

          opts.on("--api-token KEY") do |key|
            options[:api_token] = key
          end

          opts.on("--enable-ssh") do
            options[:enable_ssh] = true
          end
        end
      end
    end
  end
end
