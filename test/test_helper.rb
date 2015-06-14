$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

gem 'minitest'
require 'ruby_hashes'
require 'minitest/autorun'
require 'minitest/reporters'

Dir[File.expand_path('../helpers/**/*.rb', __FILE__)].each {|f| require(f) }

Minitest::Reporters.use!(Minitest::Reporters::ProgressReporter.new)
