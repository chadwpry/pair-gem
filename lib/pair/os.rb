module Pair
  module OS
    def self.linux?
      RUBY_PLATFORM =~ /linux/
    end

    def self.os_x?
      RUBY_PLATFORM =~ /darwin/
    end
  end
end
