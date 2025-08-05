# frozen_string_literal: true

require 'logger'
require 'time'

module Reaxar
  module Middleware
    # Middleware for logging HTTP requests and responses.
    #
    # @example Usage
    #   logger = Logger.new($stdout)
    #   middleware = Reaxar::Middleware::Log.new(logger)
    #
    # @!attribute [r] logger
    #   @return [Logger] The logger used for output.
    class Log < MiddlewareAbstract
      # Initializes the Log middleware.
      # @param logger [Logger, nil] Logger instance for output (defaults to $logger).
      def initialize(logger = nil)
        super()
        @logger = logger || Logger.new($stdout)
      end

      # Logs information about the HTTP request.чц
      # @param request [Hash] The request data.
      # @return [Hash] The original request.
      def process_request(request)
        @start_time = Time.now
        log_request_info(request, @start_time)
        log_request_headers(request)
        request
      end

      # Logs information about the HTTP response.
      # @param response [Object] The HTTP response.
      # @param request [Hash] The original request.
      # @return [Object] The HTTP response.
      def process_response(response, request)
        duration = Time.now - @start_time
        status = response.respond_to?(:status) ? response.status : '???'
        log_response_info(request, response, status, duration)
        log_response_headers(response)
        response
      end

      private

      def log_request_info(request, _start_time)
        @logger.info("➡️  [#{@start_time.iso8601}] #{request[:method].upcase} #{request[:uri]}")
      end

      def log_request_headers(request)
        return unless request[:headers] && !request[:headers].empty?

        @logger.info('Request headers:')
        request[:headers].each do |key, value|
          @logger.info("  #{key}: #{value}")
        end
      end

      def log_response_info(request, _response, status, duration)
        @logger.info("⬅️  [#{Time.now.iso8601}] #{request[:method].upcase} #{request[:uri]} - " \
        "#{status} (#{duration.round(2)}s)")
      end

      def log_response_headers(response)
        return unless response.respond_to?(:headers) && response.headers && !response.headers.empty?

        @logger.info('Response headers:')
        response.headers.each do |key, value|
          @logger.info("  #{key}: #{value}")
        end
      end
    end
  end
end
