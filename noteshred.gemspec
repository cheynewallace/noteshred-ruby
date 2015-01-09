# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'noteshred/version'

Gem::Specification.new do |spec|
  spec.name          = 'noteshred'
  spec.version       = Noteshred::VERSION
  spec.authors       = ['Cheyne Wallace']
  spec.email         = ['cheyne.wallace@gmail.com']
  spec.summary       = %q{Gem for interacting with the NoteShred API}
  spec.description   = %q{Gem for interacting with the NoteShred API via HTTPS returning JSON payloads}
  spec.homepage      = 'https://github.com/cheynewallace/noteshred-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.0', '>= 10.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0', '>= 3.0.0'

  spec.add_dependency 'rest-client', '~> 1.7', '>= 1.7.2'
  spec.add_dependency 'bcrypt', '~> 3.1', '>= 3.1.7'
end
