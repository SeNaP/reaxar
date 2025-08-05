# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

RuboCop::RakeTask.new(:rubocop)

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb'] # можно добавить другие папки
  t.options = ['--output-dir', 'doc']
end
