require '../lib/reaxar/client'
require '../lib/reaxar/page'

Reaxar::Page.open('https://github.com') do |page|
  puts page.title
end
