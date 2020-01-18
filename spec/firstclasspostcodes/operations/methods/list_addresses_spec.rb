# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes::Operations::Methods::ListAddresses do
  class TestListAddresses < Hash
    include Firstclasspostcodes::Operations::Methods::ListAddresses
  end

  subject { TestListAddresses[] }

  specify { expect(subject.respond_to?(:list_addresses)) }

  describe "when there are no numbers or streets" do
    before(:each) do
      subject.merge!(
        numbers: [],
        streets: [],
        locality: "locality",
        city: "city",
        postcode: "postcode"
      )
    end

    it "returns a postcode option" do
      expect(subject.list_addresses).to eq([
        ["postcode:0", "city, postcode"],
      ])
    end
  end

  describe "when there are only streets" do
    before(:each) do
      subject.merge!(
        numbers: [],
        streets: ["A Street", "B Avenue"],
        locality: "locality",
        city: "city",
        postcode: "postcode"
      )
    end

    it "returns equal number of street options" do
      expect(subject.list_addresses).to eq([
        ["streets:0", "A Street, city, postcode"],
        ["streets:1", "B Avenue, city, postcode"],
      ])
    end
  end

  describe "when there are streets and numbers" do
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
        streets: ["A Street", "B Avenue"],
        locality: "locality",
        city: "city",
        postcode: "postcode"
      )
    end

    it "returns equal number of street options" do
    end
  end
end
