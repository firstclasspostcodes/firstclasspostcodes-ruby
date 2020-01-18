# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes::Operations::Methods::FormatAddress do
  class TestFormatAddress < Hash
    include Firstclasspostcodes::Operations::Methods::FormatAddress
  end

  subject { TestFormatAddress[] }

  let(:index) { "numbers:0" }

  before(:each) do
    subject.merge!(
      numbers: [
        {
          number: 1,
          street: "A Street",
        },
        {
          number: "Flat A",
          building: "Crescent",
          street: "A Street",
        },
      ],
      streets: [
        "A Street",
        "B Avenue",
      ],
      locality: "locality",
      city: "city",
      county: "county",
      region: "region",
      country: "country",
      postcode: "postcode"
    )
  end

  specify { expect(subject.respond_to?(:format_address)) }

  describe "when the type is invalid" do
    let(:index) { "dadwadada:0" }

    it "throws an error" do
      expect { subject.format_address(index) }.to raise_error(StandardError)
    end
  end

  describe 'when the "postcode" type is passed in' do
    let(:index) { "postcode:0" }

    it "returns a formatted postcode" do
      expect(subject.format_address(index)).to eq(
        locality: "city",
        region: "county",
        postcode: "postcode",
        country: "country"
      )
    end
  end

  describe 'when the "streets" type is passed in' do
    let(:index) { "streets:1" }

    it "returns a formatted street" do
      expect(subject.format_address(index)).to eq(
        address: "B Avenue",
        locality: "city",
        region: "county",
        postcode: "postcode",
        country: "country"
      )
    end

    describe "when there are no streets" do
      before(:each) { subject[:streets] = nil }

      it "throws an error" do
        expect { subject.format_address(index) }.to raise_error(StandardError)
      end
    end
  end

  describe 'when the "numbers" type is passed in' do
    let(:index) { "numbers:1" }

    it "returns a formatted number" do
      expect(subject.format_address(index)).to eq(
        address: "Flat A, Crescent, A Street",
        locality: "city",
        region: "county",
        postcode: "postcode",
        country: "country"
      )
    end

    describe "when there are no numbers" do
      before(:each) { subject[:numbers] = nil }

      it "throws an error" do
        expect { subject.format_address(index) }.to raise_error(StandardError)
      end
    end
  end
end
