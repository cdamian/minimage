# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "minimage/version"

Gem::Specification.new do |s|
  s.name        = "minimage"
  s.version     = Minimage::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Damian Caruso"]
  s.email       = ["damian.caruso@gmail.com"]
  s.homepage    = "http://github.com/cdamian/minimage"
  s.summary     = %q{}
  s.description = %q{}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "cuba",        "~> 3.1"
  s.add_dependency "mini_magick", "~> 3.6"
  s.add_dependency "nesty",       "~> 1.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rake"
end
