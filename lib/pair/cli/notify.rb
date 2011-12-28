module Pair
  class Cli
    class Notify < self
      def run!
        parse!

        Notification.dispatcher.gntp_notify(options)
      end

      def parse!
        opts = parse do |opts|
          opts.banner = "Usage #{$0.split("/").last} notify" +
                        "\n\n" +
                        "Options:" +
                        "\n"

          opts.on("-t", "--title title") do |title|
            options[:title] = title
          end

          opts.on("-n", "--notification name") do |name|
            options[:name] = name
          end

          opts.on("-m", "--message text") do |text|
            options[:text] = text
          end

          opts.on("-i", "--icon url") do |url|
            options[:icon] = url
          end

          opts.on("-s", "--sticky") do
            options[:sticky] = true
          end
        end
      end
    end
  end
end
