# frozen_string_literal: true

require '../lib/reaxar/client'
require '../lib/reaxar/page'
require 'logger'
require 'async'

start_time = Time.now
tasks = []

Async do |task|
  3.times do
    tasks << task.async { Reaxar::Client.new(Logger.new(nil)).get('https://httpbun.com/delay/5') }
  end
end

responses = tasks.map(&:wait)

responses.each do |res|
  puts res.read
end

duration = Time.now - start_time
puts "⏱ Total time: #{duration.round(2)} sec"
