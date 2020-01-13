# frozen_string_literal: true

require "firstclasspostcodes/client"
require "firstclasspostcodes/configuration"
require "firstclasspostcodes/events"
require "firstclasspostcodes/operations"
require "firstclasspostcodes/version"

module Firstclasspostcodes
  class << self
    # Customize default settings for the SDK using block.
    #   Firstclasspostcodes.configure do |config|
    #     config.api_key = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end

  class Client
    include Operations
    include Events
  end
end
