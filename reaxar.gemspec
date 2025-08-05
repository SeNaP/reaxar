# frozen_string_literal: true

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

  spec.add_dependency 'async-http'
  spec.add_dependency 'nokogiri'
end
