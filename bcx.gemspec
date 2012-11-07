# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bcx/version'

Gem::Specification.new do |gem|
  gem.name          = "bcx"
  gem.version       = Bcx::VERSION
  gem.authors       = ["Anton Zaytsev"]
  gem.email         = ["me@antonzaytsev.com"]
  gem.description   = %q{TODO: Basecamp new ruby api wrapper}
  gem.summary       = %q{TODO: Provides simple methods to work with basecamp new api}
  gem.homepage      = ""

  gem.rubyforge_project = 'bcx'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  gem.add_runtime_dependency "httparty"
  gem.add_runtime_dependency "json"
end
