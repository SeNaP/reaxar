require 'spec_helper'

RSpec.describe Reaxar::Middleware::Redirect do
  let(:middleware) { described_class.new }

  let(:request) do
    {
      uri: 'http://example.com/start',
      method: :post
    }
  end

  let(:response_no_redirect) do
    double('Response', status: 200, headers: {})
  end

  let(:response_with_absolute_redirect) do
    double('Response', status: 302, headers: { 'location' => 'http://example.com/next' })
  end

  let(:response_with_relative_redirect) do
    double('Response', status: 301, headers: { 'location' => '/next' })
  end

  it 'passes through response with no location header' do
    result = middleware.process_response(response_no_redirect, request.dup)
    expect(result).to eq(response_no_redirect)
  end

  it 'follows absolute redirect and modifies request' do
    req = request.dup
    req[:redirect_count] = 0

    result = middleware.process_response(response_with_absolute_redirect, req)

    expect(req[:redirect_count]).to eq(1)
    expect(req[:uri]).to eq('http://example.com/next')
    expect(req[:method]).to eq(:get)
    expect(result).to eq(:retry_request)
  end

  it 'follows relative redirect and resolves URI' do
    req = request.dup
    req[:redirect_count] = 0

    result = middleware.process_response(response_with_relative_redirect, req)

    expect(req[:uri]).to eq('http://example.com/next')
    expect(req[:method]).to eq(:get)
    expect(result).to eq(:retry_request)
  end

  it 'stops redirect if max redirects reached' do
    req = request.dup
    req[:redirect_count] = 5

    result = middleware.process_response(response_with_relative_redirect, req)

    expect(result).to eq(response_with_relative_redirect)
  end

  it 'initializes redirect_count to 0 if not set' do
    req = request.dup
    expect(middleware.process_request(req)[:redirect_count]).to eq(0)
  end
end
