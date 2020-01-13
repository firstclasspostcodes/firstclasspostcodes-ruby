# frozen_string_literal: true

require "uri"
require "simplecov"

SimpleCov.start

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

# load the gem
require "firstclasspostcodes"

API_URL = ENV["API_URL"]

API_KEY = ENV["API_KEY"]

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    uri = URI.parse(API_URL)

    Firstclasspostcodes.configure do |c|
      c.api_key = API_KEY
      c.base_path = uri.path
      c.protocol = uri.scheme
      c.host = uri.host
      c.host = "#{uri.host}:#{uri.port}" if uri.port
    end
  end
end
