# coding: utf-8
require File.expand_path('../lib/defines/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'btce-api'
  spec.version       = Btce::Api::VERSION
  spec.authors       = %w(Maxim Kouprianov)
  spec.email         = %w(maxim@kouprianov.com)
  spec.description   = %q{The BTC-E Ruby API Library}
  spec.summary       = %q{Introduces a handy interface for API requests and useful containers for results}
  spec.homepage      = 'https://github.com/Xlab/btce'
  spec.license       = 'zlib'
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
