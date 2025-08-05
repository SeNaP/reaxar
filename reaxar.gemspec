# frozen_string_literal: true
require_relative 'lib/reaxar/version'

Gem::Specification.new do |spec|
  spec.name          = 'reaxar'
  spec.version       = Reaxar::VERSION
  spec.authors       = ['Petr Ustyugov']
  spec.email         = ['peter.ustyugov@gmail.com']
  spec.summary       = 'Asynchronous Simple HTTP browser'
  spec.description = <<~DESC
    Reaxar is a lightweight asynchronous HTTP/REST client for Ruby, built on top of async-http.
    It features automatic cookie management, support for redirects and relative navigation,
    and is ideal for scraping, API interaction, or automated web flows.

    Perfect for developers who need a non-blocking HTTP client with session awareness and simple request chaining.
  DESC
  spec.homepage      = 'https://github.com/senap/reaxar'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "async-http", "~> 0.89.0"
  spec.add_dependency "nokogiri", "~> 1.18"
end
