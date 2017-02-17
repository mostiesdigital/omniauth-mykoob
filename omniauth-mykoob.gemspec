# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-mykoob/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-mykoob'
  s.version     = Omniauth::Mykoob::VERSION
  s.authors     = ['Armands Leinieks']
  s.email       = ['armands.leinieks@gmail.com']
  s.summary     = 'Mykoob authentication strategy for OmniAuth'
  s.description = s.summary
  s.homepage    = 'http://github.com/mostiesdigital/omniauth-mykoob'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^spec/})
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth', '~> 1.0'
  s.add_runtime_dependency 'rest-client', '~> 1.6'

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake'
end
