require 'spec_helper'
require 'uri'
require 'reaxar/element/a'

RSpec.describe Reaxar::Element::A do
  let(:element) { { href: '/about' } }
  let(:page_double) { double('Page', url: 'http://example.com/', client: :some_client) }
  subject(:link) { described_class.new(element, page_double) }

  describe '#href' do
    it 'returns the absolute URL based on the page URL and element href' do
      expect(link.href).to eq('http://example.com/about')
    end
  end

  describe '#click' do
    it 'opens a new page using the href and page client' do
      expect(Reaxar::Page).to receive(:open).with('http://example.com/about', :some_client)
      link.click
    end

    it 'yields self if block is given' do
      allow(Reaxar::Page).to receive(:open).and_yield(:new_page)
      result = nil
      link.click { |p| result = p }
      expect(result).to eq(:new_page)
    end
  end
end
