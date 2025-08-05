# frozen_string_literal: true

require 'async/http/internet'
require_relative 'middleware/middleware_stack'
require_relative 'middleware/redirect'
require_relative 'middleware/log'

module Reaxar
  # HTTP client for performing asynchronous web requests with middleware support.
  #
  # @example Basic usage
  #   client = Reaxar::Client.new(Logger.new($stdout))
  #   response = client.get('https://example.com')
  #   puts response.read
  #
  # @!attribute [r] cookies
  #   @return [Hash] The cookies stored by the client, keyed by cookie name.
  class Client
    attr_reader :cookies

    # Initializes a new Client instance.
    # @param logger [Logger, nil] Logger instance for logging requests (optional).
    def initialize(logger)
      @cookies = {}
      @logger = logger || Logger.new($stdout)
      @internet = Async::HTTP::Internet.new
      @middleware = Reaxar::Middleware::MiddlewareStack.new

      @middleware.use Reaxar::Middleware::Log.new(@logger)
    end

    # Performs an HTTP GET request.
    # @param uri [String] The URI to request.
    # @return [Object] The HTTP response object.
    def get(uri)
      request(uri, :get)
    end

    # Performs an HTTP POST request.
    # @param uri [String] The URI to request.
    # @param form_data [Hash] The form data to send in the POST body.
    # @return [Object] The HTTP response object.
    def post(uri, form_data = {})
      request(uri, :post, form_data)
    end

    # Closes the underlying HTTP connection.
    # @return [void]
    def close
      @internet.close
    end

    # Adds a middleware to the middleware stack.
    # @param middleware_class [Class] The middleware class to add.
    # @param args [Array] Arguments to pass to the middleware initializer.
    # @yield [block] Optional block for middleware initialization.
    # @return [void]
    def use(middleware_class, *args, &block)
      @middleware.use(middleware_class.new(*args, &block))
    end

    private

    # Internal method to perform an HTTP request with middleware processing.
    # @param uri [String] The URI to request.
    # @param method [Symbol] The HTTP method (:get, :post, etc.).
    # @param body [Object, nil] The request body (for POST, etc.).
    # @return [Object] The processed HTTP response.
    def request(uri, method, body = nil) # rubocop:disable Metrics/MethodLength
      request_env = {
        uri:,
        method:,
        body:,
        headers: {},
        cookies: @cookies
      }

      loop do
        # Process request through middleware
        processed_request = @middleware.run(request_env)

        # Execute HTTP request
        response = execute_http_request(
          processed_request[:uri],
          processed_request[:method],
          processed_request[:body],
          processed_request[:headers]
        )

        # Process response through middleware
        middleware_result = @middleware.process_response(response, processed_request)

        # Retry request if needed (e.g., redirect)
        if middleware_result == :retry_request
          request_env = processed_request
          next
        end

        # Update cookies if needed
        # update_cookies(middleware_result, URI(processed_request[:uri]).host)

        return middleware_result
      end
    end

    # Executes the actual HTTP request using Async::HTTP::Internet.
    # @param uri [String] The URI to request.
    # @param method [Symbol] The HTTP method.
    # @param body [Object, nil] The request body.
    # @param headers [Hash] The request headers.
    # @return [Object] The HTTP response.
    def execute_http_request(uri, method, body, headers)
      url = URI(uri)
      headers = headers.merge(headers_with_cookies(url))

      case method
      when :get
        @internet.get(url, headers)
      when :post
        headers['Content-Type'] = 'application/x-www-form-urlencoded'
        @internet.post(url, headers, URI.encode_www_form(body))
      end
    end

    # Builds headers including cookies for the given URL.
    # @param url [URI] The URI object.
    # @return [Hash] The headers including the 'Cookie' header if cookies are present.
    def headers_with_cookies(url)
      return {} if @cookies.empty?

      domain_cookies = @cookies.select { |_key, cookie| cookie[:domain] == url.host }
      cookie_string = domain_cookies.map { |key, cookie| "#{key}=#{cookie[:value]}" }.join('; ')

      { 'Cookie' => cookie_string }
    end

    # Updates the client's cookies from the response.
    # @param response [Object] The HTTP response object.
    # @return [void]
    def update_cookies(response)
      return unless response.headers['set-cookie']

      response.headers['set-cookie'].split("\n").each do |cookie|
        name, value = cookie.split('=', 2).map(&:strip)
        value = value.split(';').first

        @cookies[name] = {
          value:,
          domain: response.endpoint.host,
          path: '/'
        }
      end
    end
  end
end
