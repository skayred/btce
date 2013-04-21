# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'btce/defines/version'

Gem::Specification.new do |spec|
  spec.name          = 'btce-api'
  spec.version       = Btce::Api::VERSION
  spec.authors       = %w(Maxim Kouprianov)
  spec.email         = %w(maxim@kouprianov.com)
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ''
  spec.license       = 'zlib'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
