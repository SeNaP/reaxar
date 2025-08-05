# frozen_string_literal: true

require_relative 'reaxar/client'
require_relative 'reaxar/page'
require_relative 'reaxar/element/a'
require_relative 'reaxar/middleware/redirect'

module Reaxar
  class Error < StandardError; end
end
