require 'spec_helper'
require 'logger'

RSpec.describe Reaxar::Page do
  before do
    Reaxar::Page.configure(logger: Logger.new(nil))
  end

  it 'sync parses a stubbed page with html elements' do
    page = Reaxar::Page.open('https://example.com').wait

    expect(page).to be_a(Reaxar::Page)
    expect(page.document.at('h1').text).to eq('Hello from stub')
    expect(page.links.count).to eq(2)
  end

  it 'async parses a stubbed page with html elements' do
    Reaxar::Page.open('https://example.com') do |page|
      expect(page).to be_a(Reaxar::Page)
      expect(page.document.at('h1').text).to eq('Hello from stub')
      expect(page.links.count).to eq(2)
    end
  end
end
