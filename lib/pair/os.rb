module Pair
  module OS
    def linux?
      RUBY_PLATFORM =~ /linux/
    end

    def self.x?
      RUBY_PLATFORM =~ /darwin/
    end
  end
end
