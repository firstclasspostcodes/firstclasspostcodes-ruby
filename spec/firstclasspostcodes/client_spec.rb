# frozen_string_literal: true

require "spec_helper"
require "json"

require_relative "../support/events_examples.rb"

describe Firstclasspostcodes::Client do
  subject { Firstclasspostcodes::Client.new }

  it_behaves_like "a class that emits events" do
    subject { Firstclasspostcodes::Client.new }
  end

  specify { expect(subject).to respond_to(:get_postcode) }

  specify { expect(subject).to respond_to(:get_lookup) }

  describe "#config" do
    specify { expect(subject.config).to be_instance_of(Firstclasspostcodes::Configuration) }
  end

  describe "#user_agent" do
    specify { expect(subject).not_to respond_to(:user_agent=) }

    specify { expect(subject.user_agent).to include Firstclasspostcodes::VERSION }
  end

  describe "#request" do
  end

  describe "#call_request" do
    describe "successful request" do
      let(:stubbed_response) { Typhoeus::Response.new(code: 200, body: "test") }

      before(:each) { Typhoeus.stub(/test/).and_return(stubbed_response) }

      specify { expect(subject.call_request("www.test.com")).to eq(stubbed_response) }
    end

    describe "unsuccessful request" do
      let(:stubbed_response) { Typhoeus::Response.new(code: 403, body: "forbidden") }

      before(:each) { Typhoeus.stub(/test/).and_return(stubbed_response) }

      before(:each) { instance_double }
    end
  end

  describe "#handle_request_error" do
    describe "when request is timed out" do
      let(:response) { double(timed_out?: true) }

      specify { expect { subject.handle_request_error(response) }.to raise_error(Firstclasspostcodes::ResponseError) }
    end

    describe "when there was a libcurl error" do
      let(:response) { double(timed_out?: false, code: 0, return_message: "message") }

      specify { expect { subject.handle_request_error(response) }.to raise_error(Firstclasspostcodes::ResponseError) }
    end

    describe "when there was an api error" do
      describe "when the response is JSON" do
        let(:response) { double(timed_out?: false, code: 500, body: '{ "err": "message" }') }

        specify { expect { subject.handle_request_error(response) }.to raise_error(Firstclasspostcodes::ResponseError) }
      end

      describe "when the response cannot be parsed" do
        let(:response) { double(timed_out?: false, code: 500, body: "error message") }

        specify { expect { subject.handle_request_error(response) }.to raise_error(Firstclasspostcodes::ResponseError) }
      end
    end
  end

  describe "#build_request_url" do
    let(:path) { "/test" }

    specify { expect(subject.build_request_url(path)).to include path }
  end
end
