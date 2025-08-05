# frozen_string_literal: true

module Reaxar
  module Middleware
    # Abstract base class for HTTP middleware.
    #
    # All middleware should inherit from this class and implement
    # the {#process_request} and {#process_response} methods.
    #
    # @abstract
    class MiddlewareAbstract
      # Processes the HTTP request before it is sent.
      # @param request [Hash] The request data.
      # @return [Hash] The modified request.
      # @raise [NotImplementedError] If not implemented in subclass.
      def process_request(request)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      # Processes the HTTP response after it is received.
      # @param response [Object] The HTTP response.
      # @param _request [Hash] The original request.
      # @return [Object] The modified response.
      # @raise [NotImplementedError] If not implemented in subclass.
      def process_response(response, request)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
