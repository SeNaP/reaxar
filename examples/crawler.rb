# frozen_string_literal: true

require 'async'
require 'async/await'
require '../lib/reaxar/client'
require '../lib/reaxar/page'

class Crawler
  include Async::Await

  DEPTH_SEARCH_LINK = 5

  def initialize
    @logger = Logger.new($stdout)
    @urls = Array.new(10) { |i| "https://habr.com/ru/articles/9333#{i + 1}/" }
    Reaxar::Page.configure(logger: @logger)
  end

  def handler(page, depth = 0)
    return if depth > DEPTH_SEARCH_LINK

    @logger.info "🔥 Status: #{page.response.status}"
    @logger.info  "🖥  Page opened: #{page.url}"
    @logger.info  "📌 Title: #{page.title}"
    @logger.info  "🔗 Links count: #{page.links.size}"
    link = page.links.select { |l| l.href.include?('https://habr.com/') }.sample
    @logger.info "👉 LINK TO CLICK: #{link.href}"
    sleep 3
    link.click do |liknk|
      handler(liknk, depth + 1)
    end
  end

  async def run
    @urls.map do |url|
      Reaxar::Page.open(url) do |page|
        handler(page)
      end
    end
  end
end

Crawler.new.run
