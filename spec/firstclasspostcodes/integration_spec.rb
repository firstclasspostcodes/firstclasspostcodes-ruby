# frozen_string_literal: true

require "spec_helper"
require "json"

require_relative "../support/events_examples.rb"

DATA_PATH = "/data/.postcodes"

describe Firstclasspostcodes::Client do
  subject { Firstclasspostcodes::Client.new }

  let(:fixtures) { subject.request(method: :get, path: DATA_PATH) }

  let(:fixture) { fixtures.sample }

  describe "#get_postcode" do
    it "retrieves the postcode correctly" do
      response = subject.get_postcode(fixture[:postcode])
      expect(response[:postcode]).to eq(fixture[:postcode])
    end
  end

  describe "#get_lookup" do
    it "retrieves postcodes by geolocation correctly" do
      response = subject.get_lookup(fixture)
      expect(response[0][:postcode]).to eq(fixture[:postcode])
    end
  end
end
