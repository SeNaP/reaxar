# frozen_string_literal: true

module Reaxar
  module Element
    # Represents an HTML anchor (`<a>`) element on a page.
    #
    # @example Accessing link attributes and clicking
    #   link = Reaxar::Element::A.new(nokogiri_element, page)
    #   puts link.href
    #   link.click { |new_page| puts new_page.title }
    #
    # @!attribute [r] element
    #   @return [Nokogiri::XML::Element] The underlying Nokogiri element.
    # @!attribute [r] page
    #   @return [Reaxar::Page] The page this element belongs to.
    class A
      attr_reader :element, :page

      # Initializes a new anchor element wrapper.
      # @param element [Nokogiri::XML::Element] The Nokogiri element.
      # @param page [Reaxar::Page] The parent page.
      def initialize(element, page)
        @element = element
        @page = page
      end

      # Returns the absolute URL for the link.
      # @return [String] The resolved href attribute.
      def href
        URI.join(page.url, element[:href]).to_s
      end

      # Opens the link in a new page context.
      # @yield [page] Optional block with the new page instance.
      # @return [Async::Task] The async task wrapping the new page.
      def click(&block)
        Page.open(href, page.client, &block)
      end
    end
  end
end
