# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pair/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bodaniel Jeanes", "Chad W. Pry"]
  gem.email         = ["me@bjeanes.com", "chad.pry@gmail.com"]
  gem.description   = %q{Effortless remote pairing}
  gem.summary       = %q{Pair with remote programmers with a single command.}
  gem.homepage      = "http://www.pairmill.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "pair"
  gem.require_paths = ["lib"]
  gem.version       = Pair::VERSION

  gem.add_dependency("httparty", "~> 0.8.1")

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec", "~> 2.3.0")
end
