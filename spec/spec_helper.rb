require 'bundler/setup'
require 'reaxar'

require 'webmock/rspec'
require_relative 'support/webmock'
# require 'async/rspec'

RSpec.configure do |config|
  # config.include Async::RSpec::Reactor

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!
  config.warnings = false
end
