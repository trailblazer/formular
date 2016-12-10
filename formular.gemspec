lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formular/version'

Gem::Specification.new do |spec|
  spec.name          = "formular"
  spec.version       = Formular::VERSION
  spec.authors       = ["Nick Sutterer", "Fran Worley"]
  spec.email         = ["apotonick@gmail.com", "frances@safetytoolbox.co.uk"]

  spec.summary       = %q{Form builder based on Cells. Fast, Furious, and Framework-Agnostic.}
  spec.description   = %q{Customizable, fast form builder based on Cells. Framework-agnostic.}
  spec.homepage      = "http://trailblazer.to/gems/formular.html"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency             "declarative",    '~> 0.0.4'
  spec.add_dependency             "uber",           ">= 0.0.11", "< 0.2.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "trailblazer-cells"
  spec.add_development_dependency "cells-slim"
  spec.add_development_dependency "cells-erb"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-line"
end
