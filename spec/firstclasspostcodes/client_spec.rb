# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes::Client do
  it "should load correctly" do
    c = Firstclasspostcodes::Client.new
    puts c.hello
  end
end
