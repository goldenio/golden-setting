# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'golden/setting/version'

Gem::Specification.new do |spec|
  spec.name          = 'golden-setting'
  spec.version       = Golden::Setting::VERSION
  spec.authors       = ['Tse-Ching Ho']
  spec.email         = ['tsechingho@gmail.com']
  spec.description   = %q{Golden Setting persists settings in database and keep alive in cache.}
  spec.summary       = %q{persists settings in database and keep alive in cache.}
  spec.homepage      = 'https://github.com/goldenio/golden-setting'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 3.2.13', '< 5'
  spec.add_dependency 'railties', '>= 3.2.13', '< 5'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 2.13.0'
  spec.add_development_dependency 'sqlite3'
end
