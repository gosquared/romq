# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'romq/version'

Gem::Specification.new do |gem|
  gem.name          = 'romq'
  gem.version       = RoMQ::VERSION
  gem.authors       = ['Gerhard Lazu']
  gem.email         = ['gerhard@lazu.co.uk']
  gem.description   = %q{Gracefully handle common amqp exceptions for more robust clients.}
  gem.summary       = %q{Cluster-aware amqp client library, never gives up on reconnecting.}
  gem.homepage      = 'https://github.com/gosquared/romq'

  gem.files         = Dir['lib/**/*', 'examples/**/*', 'Gemfile', 'README.md']
  # examples/client.rb will have to do for now
  # gem.test_files    = Dir['test/**/*']
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'amqp', '~> 0.9.7'
end
