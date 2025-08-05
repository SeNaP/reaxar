require 'spec_helper'
require 'reaxar/middleware/log'
require 'logger'
require 'stringio'

RSpec.describe Reaxar::Middleware::Log do
  let(:log_output) { StringIO.new }
  let(:logger)     { Logger.new(log_output) }
  let(:middleware) { described_class.new(logger) }

  let(:request) do
    { method: 'get', uri: URI('http://example.com') }
  end

  let(:response) do
    double('Response', status: 200)
  end

  it 'logs the request' do
    middleware.process_request(request)
    expect(log_output.string).to include('GET http://example.com')
  end

  it 'logs the response' do
    middleware.process_request(request)
    middleware.process_response(response, request)
    expect(log_output.string).to include('200')
  end
end
