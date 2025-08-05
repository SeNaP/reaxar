# frozen_string_literal: true

require_relative 'middleware_abstract'

module Reaxar
  module Middleware
    # Middleware for handling HTTP redirects.
    #
    # @example
    #   middleware = Reaxar::Middleware::Redirect.new
    #
    # @!attribute [r] redirect_count
    #   @return [Integer] The number of redirects for the request.
    class Redirect < MiddlewareAbstract
      # The maximum number of allowed redirects.
      MAX_REDIRECTS = 5

      # Initializes the Redirect middleware.
      def initialize
        super
        @redirect_count = 0
      end

      # Initializes the redirect counter for the request.
      # @param request [Hash] The request data.
      # @return [Hash] The modified request.
      def process_request(request)
        request[:redirect_count] ||= 0
        request
      end

      # Processes the HTTP response and handles redirects if needed.
      # @param response [Object] The HTTP response.
      # @param request [Hash] The original request.
      # @return [Object, Symbol] The response or :retry_request for another attempt.
      def process_response(response, request)
        return response unless response.headers['location']
        return response if request[:redirect_count] >= MAX_REDIRECTS

        request[:redirect_count] += 1

        redirect_uri = process_location_url(request, response)

        request[:uri] = redirect_uri
        request[:method] = :get if [301, 302].include?(response.status)

        :retry_request
      end

      private

      def process_location_url(request, response)
        location = response.headers['location']
        base_uri = URI(request[:uri])
        if location.start_with?('http')
          location
        else
          "#{base_uri.scheme}://#{base_uri.host}#{location}"
        end
      end
    end
  end
end
