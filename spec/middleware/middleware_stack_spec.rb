require 'spec_helper'

RSpec.describe Reaxar::Middleware::MiddlewareStack do
  let(:stack) { described_class.new }
  let(:request) { { method: :get, uri: 'http://example.com' } }
  let(:response) { double('Response', status: 200) }

  let(:middleware1) do
    Class.new do
      def process_request(req)
        req[:middleware1] = true
        req
      end

      def process_response(resp, _req)
        resp
      end
    end.new
  end

  let(:middleware2) do
    Class.new do
      def process_request(req)
        req[:middleware2] = true
        req
      end

      def process_response(resp, _req)
        resp
      end
    end.new
  end

  it 'applies all middlewares in order to request' do
    stack.use(middleware1)
    stack.use(middleware2)

    result = stack.run(request.dup)
    expect(result[:middleware1]).to be true
    expect(result[:middleware2]).to be true
  end

  it 'applies all middlewares in reverse order to response' do
    order = []

    m1 = Class.new do
      define_method(:process_request) { |req| req }
      define_method(:process_response) do |resp, _req|
        order << :m1
        resp
      end
    end.new

    m2 = Class.new do
      define_method(:process_request) { |req| req }
      define_method(:process_response) do |resp, _req|
        order << :m2
        resp
      end
    end.new

    stack.use(m1)
    stack.use(m2)

    stack.process_response(response, request)
    expect(order).to eq(%i[m2 m1])
  end

  it 'returns :retry_request if a middleware requests retry' do
    retry_middleware = Class.new do
      def process_request(req) = req

      def process_response(_resp, _req)
        :retry_request
      end
    end.new

    stack.use(retry_middleware)

    result = stack.process_response(response, request)
    expect(result).to eq(:retry_request)
  end

  it 'falls back to original request/response if middleware returns nil' do
    null_middleware = Class.new do
      def process_request(_req) = nil
      def process_response(_resp, _req) = nil
    end.new

    stack.use(null_middleware)

    req_result = stack.run(request)
    resp_result = stack.process_response(response, request)

    expect(req_result).to eq(request)
    expect(resp_result).to eq(response)
  end
end
