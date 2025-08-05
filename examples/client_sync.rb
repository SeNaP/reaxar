# frozen_string_literal: true

require '../lib/reaxar/client'
require '../lib/reaxar/page'
require 'logger'
require 'async'

start_time = Time.now
responses = []

3.times do
  responses << Sync { Reaxar::Client.new(Logger.new($stdout)).get('https://httpbun.com/delay/5') }
end

responses.each do |res|
  p res.read
end

duration = Time.now - start_time
puts "⏱ Total time: #{duration.round(2)} sec"
