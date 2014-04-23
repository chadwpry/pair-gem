# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pair/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bodaniel Jeanes", "Chad W. Pry", "Mr and Mrs Tree"]
  gem.email         = ["me@bjeanes.com", "chad.pry@gmail.com", "bumblebee@tree.com"]
  gem.description   = %q{When you just need to talk to a tree, pair!}
  gem.summary       = %q{Pair with trees. they're cool}
  gem.homepage      = "http://wwww.420.org"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "tree-pair"
  gem.license       = "The Tree"
  gem.require_paths = ["lib"]
  gem.version       = Pair::VERSION

  gem.add_dependency("httparty", "~> 0.8.1")
  gem.add_dependency("ruby_gntp", "~> 0.3.4")

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec", "~> 2.7.0")
end
