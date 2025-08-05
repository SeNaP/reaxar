require 'spec_helper'
require 'async/rspec'
require 'logger'

RSpec.describe Reaxar::Client do
  include_context Async::RSpec::Reactor

  let(:client) { described_class.new(Logger.new(nil)) }

  describe '#get' do
    it 'should return 200 status' do
      Sync do
        response = client.get('https://example.com')
        expect(response.status).to eq(200)
        expect(response.read).to include('Hello from stub')
      end
    end
  end

  describe '#post' do
  end

  describe '#put' do
  end

  describe '#update' do
  end

  describe '#delete' do
  end

  describe 'async requests' do
    it 'executes requests in parallel' do
      responses = []
      tasks = []
      start_time = Time.now

      Async do |task|
        3.times.map do
          tasks << task.async do
            resp = client.get('https://example.com/delay/1')
            responses << resp
          end
        end

        tasks.each(&:wait)
      end.wait

      duration = Time.now - start_time

      expect(responses.map(&:read)).to eq(%w[OK OK OK])
      expect(duration).to be < 1.5
      expect(responses.map(&:status)).to all(eq(200))
    end
  end

  describe 'sequential requests' do
    it 'takes at least 3 seconds for sequential requests' do
      start_time = Time.now
      responses = []

      Async do |_task|
        tasks = 3.times.map do
          resp = client.get('https://example.com/delay/1')
          responses << resp
        end
      end.wait

      duration = Time.now - start_time

      expect(responses.map(&:read)).to eq(%w[OK OK OK])
      expect(duration).to be >= 3
      expect(responses.map(&:status)).to all(eq(200))
    end
  end
end
