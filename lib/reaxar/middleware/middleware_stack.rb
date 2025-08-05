# frozen_string_literal: true

module Reaxar
  module Middleware
    # Manages a stack of HTTP middleware and applies them to requests and responses.
    #
    # @example
    #   stack = Reaxar::Middleware::MiddlewareStack.new
    #   stack.use(MyMiddleware.new)
    #   request = stack.run(request)
    #   response = stack.process_response(response, request)
    class MiddlewareStack
      # Initializes a new, empty middleware stack.
      def initialize
        @stack = []
      end

      # Adds a middleware to the stack.
      # @param middleware [Object] The middleware instance to add.
      # @return [void]
      def use(middleware)
        @stack << middleware
      end

      # Runs all middleware on the request in order.
      # @param request [Hash] The request data.
      # @return [Hash] The processed request.
      def run(request)
        @stack.reduce(request) do |req, middleware|
          middleware.process_request(req) || req
        end
      end

      # Runs all middleware on the response in reverse order.
      # @param response [Object] The HTTP response.
      # @param request [Hash] The original request.
      # @return [Object, Symbol] The processed response or :retry_request.
      def process_response(response, request)
        @stack.reverse.reduce(response) do |resp, middleware|
          result = middleware.process_response(resp, request)

          return :retry_request if result == :retry_request

          result || resp
        end
      end
    end
  end
end
