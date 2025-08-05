# frozen_string_literal: true

require 'nokogiri'
require_relative 'element/a'

module Reaxar
  # Represents a web page and provides methods for interacting with its content.
  #
  # @example Open a page and print its title
  #   page = Reaxar::Page.open('https://example.com')
  #   puts page.title
  #
  # @!attribute [r] url
  #   @return [String] The URL of the page.
  # @!attribute [r] client
  #   @return [Client] The HTTP client used to fetch the page.
  # @!attribute [r] response
  #   @return [Object] The HTTP response object.
  # @!attribute [r] document
  #   @return [Nokogiri::HTML::Document] The parsed HTML document.
  class Page
    attr_reader :url, :client, :response, :document

    class << self
      # @!attribute [rw] logger
      #   @return [Logger, nil] The logger instance used by the client.
      attr_accessor :logger

      # Configures the logger for the Page class.
      # @param logger [Logger] The logger to use.
      # @return [void]
      def configure(logger:)
        self.logger = logger
      end
    end

    # Opens a page asynchronously.
    # @param url [String] The URL to open.
    # @param client [Client, nil] Optional HTTP client.
    # @yield [page] Optional block to yield the page instance.
    # @yieldparam page [Page] The page instance.
    # @return [Async::Task] The async task wrapping the page.
    def self.open(url, client = nil, &block)
      Async { new(url, client, &block) }
    end

    # Initializes a new Page instance.
    # @param url [String] The URL of the page.
    # @param client [Client, nil] Optional HTTP client.
    # @yield [self] Optional block to yield the page instance.
    def initialize(url, client = nil)
      @url = url
      @client = client || Client.new(self.class.logger)
      @client.use Reaxar::Middleware::Redirect
      @response = @client.get(url)
      @document = Nokogiri::HTML(@response.read)

      yield self if block_given?
    end

    # Returns the title of the page.
    # @return [String, nil] The page title or nil if not found.
    def title
      document.title
    end

    # Returns all links (<a> elements) on the page.
    # @return [Array<Reaxar::Element::A>] The array of link elements.
    def links
      @links ||= document.css('a[href]').map do |link|
        Reaxar::Element::A.new(link, self)
      end
    end

    # Returns the HTML content of the page.
    # @return [String] The HTML content.
    def html
      document.to_html
    end

    # Finds a form on the page.
    # @param selector [String] CSS selector for the form (default: 'form').
    # @return [Object, nil] The form element or nil if not found.
    def form(selector = 'form')
      # Реализация работы с формами (можно расширить)
    end

    # Submits a form on the page.
    # @param selector [String] CSS selector for the form.
    # @param data [Hash] Data to submit with the form.
    # @return [Object] The result of the form submission.
    def submit_form(selector, data = {})
      # Реализация отправки формы
    end
  end
end
