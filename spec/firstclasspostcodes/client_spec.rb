# frozen_string_literal: true

require "spec_helper"
require "json"

describe Firstclasspostcodes::Client do
  it "should load correctly" do
    c = Firstclasspostcodes::Client.new
    puts JSON.pretty_generate(c.get_postcode("ab30 1up").format_address("numbers:0"))
  end
end
