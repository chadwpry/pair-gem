require 'rbconfig'

module Pair
  module OS
    def linux?
      !RbConfig::CONFIG['target_os'].match("linux").nil?
    end

    def self.x?
      !RbConfig::CONFIG['target_os'].match("darwin").nil?
    end
  end
end
