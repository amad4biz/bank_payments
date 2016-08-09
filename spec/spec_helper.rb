require 'simplecov'
require 'coveralls'

Coveralls.wear!

SimpleCov.start do
  add_filter "/spec"
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bank_payments'
require 'byebug'
