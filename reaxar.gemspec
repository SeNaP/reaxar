# frozen_string_literal: true
require_relative 'lib/reaxar/version'

Gem::Specification.new do |spec|
  spec.name          = 'reaxar'
  spec.version       = Reaxar::VERSION
  spec.authors       = ['Petr Ustyugov']
  spec.email         = ['peter.ustyugov@gmail.com']
  spec.summary       = 'Simple HTTP browser with cookie persistence'
  spec.description   = 'REST client with cookie support and page navigation'
  spec.homepage      = 'https://github.com/senap/reaxar'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "async-http", "~> 0.89.0"
  spec.add_dependency "nokogiri", "~> 1.18"
end
