# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes::Operations::GetLookup do
  class TestGetLookup
    attr_accessor :config

    include Firstclasspostcodes::Operations::GetLookup

    def emit(event_name, properties); end

    def request(params); end
  end

  subject { TestGetLookup.new }

  let(:operation_params) { { path: "/lookup", method: :get } }

  let(:config) { double(debug?: true, logger: double(debug: nil)) }

  before(:each) { allow(subject).to receive(:emit).with(anything, anything).and_return(true) }

  before(:each) { subject.config = config }

  specify { expect(subject).respond_to?(:get_lookup) }

  describe "when the request is valid" do
    before(:each) { allow(subject).to receive(:request).and_return(nil) }

    let(:params) { { latitude: "52.3456", longitude: "-0.2567" } }

    it "resolves with the correct request parameters" do
      expected_request_params = operation_params.merge(
        query_params: {
          latitude: params[:latitude].to_f,
          longitude: params[:longitude].to_f,
          radius: anything,
        }
      )

      expect(subject).to receive(:request).with(expected_request_params)
    end

    after(:each) { subject.get_lookup(params) }
  end

  describe "when the request is invalid" do
    describe "when there are no request options" do
      it "raises an error" do
        expect { subject.get_lookup("sertgh") }.to raise_error(StandardError)
      end
    end

    describe "when the latitude is invalid" do
      let(:params) { { latitude: "4567.123", longitude: "-0.2567" } }

      it "raises an error" do
        expect { subject.get_lookup(params) }.to raise_error(StandardError)
      end
    end

    describe "when the latitude is incorrect" do
      let(:params) { { latitude: "aaaaa", longitude: "-0.2567" } }

      it "raises an error" do
        expect { subject.get_lookup(params) }.to raise_error(StandardError)
      end
    end

    describe "when the latitude is missing" do
      let(:params) { { longitude: "-0.2567" } }

      it "raises an error" do
        expect { subject.get_lookup(params) }.to raise_error(StandardError)
      end
    end

    describe "when the longitude is invalid" do
      let(:params) { { latitude: "56.123", longitude: "-23456.2567" } }

      it "raises an error" do
        expect { subject.get_lookup(params) }.to raise_error(StandardError)
      end
    end

    describe "when the longitude is incorrect" do
      let(:params) { { latitude: "56.123", longitude: "ertyhgfd" } }

      it "raises an error" do
        expect { subject.get_lookup(params) }.to raise_error(StandardError)
      end
    end

    describe "when the longitude is missing" do
      let(:params) { { latitude: "56.123" } }

      it "raises an error" do
        expect { subject.get_lookup(params) }.to raise_error(StandardError)
      end
    end
  end
end
