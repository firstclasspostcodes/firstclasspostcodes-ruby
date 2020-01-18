# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes::Operations::GetPostcode do
  class TestGetPostcode
    attr_accessor :config

    include Firstclasspostcodes::Operations::GetPostcode

    def emit(event_name, properties); end

    def request(params); end
  end

  subject { TestGetPostcode.new }

  let(:operation_params) { { path: "/postcode", method: :get } }

  let(:config) { double(geo_json?: false, debug?: true, logger: double(debug: nil)) }

  before(:each) { allow(subject).to receive(:emit).with(anything, anything).and_return(true) }

  before(:each) { subject.config = config }

  specify { expect(subject).respond_to?(:get_postcode) }

  describe "when the request is valid" do
    before(:each) { allow(subject).to receive(:request).and_return(double) }

    let(:postcode) { "test" }

    it "returns the correct response" do
      expect(subject).to receive(:request).with(operation_params.merge(
                                                  query_params: {
                                                    search: postcode,
                                                  }
                                                ))
      response = subject.get_postcode(postcode)
      expect(response).respond_to?(:list_addresses)
      expect(response).respond_to?(:format_address)
    end
  end

  describe "when the request is invalid" do
    describe "when there are no parameters" do
      it "raises an error" do
        expect { subject.get_postcode(23_456) }.to raise_error(StandardError)
      end
    end

    describe "when there is an empty string" do
      it "raises an error" do
        expect { subject.get_postcode("") }.to raise_error(StandardError)
      end
    end
  end
end
