# frozen_string_literal: true

require "spec_helper"
require "json"

describe Firstclasspostcodes::Events do
  class TestEvents
    include Firstclasspostcodes::Events
  end

  subject { TestEvents.new }

  let(:event_name) { "test" }

  let(:handler) { proc { nil } }

  describe "#on" do
    it "should add a handler for a specific event" do
      expect(subject.on(event_name, &handler)).to eq(handler.object_id)
      expect(subject.events[event_name.to_sym]).to eq([handler])
    end
  end

  describe "#off" do
    before(:each) { subject.on(event_name, &handler) }

    it "should remove a handler for a specific event" do
      subject.off(event_name, handler.object_id)
      expect(subject.events[event_name.to_sym]).to eq([])
    end
  end

  describe "#emit" do
    it "should emit an event" do
      expect do |b|
        subject.on(event_name, &b)
        subject.emit(event_name, 1)
      end.to yield_with_args(1)
    end
  end
end
