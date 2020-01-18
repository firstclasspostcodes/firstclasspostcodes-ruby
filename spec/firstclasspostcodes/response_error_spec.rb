# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes::ResponseError do
  describe "when the error is a hash" do
    let(:error_object) do
      {
        message: "message",
        docUrl: "https://google.com/some-doc",
        type: "type",
      }
    end

    subject { Firstclasspostcodes::ResponseError.new(error_object) }

    specify { expect(subject.message).to include error_object[:message] }

    specify { expect(subject.type).to include error_object[:type] }

    specify { expect(subject.message).to include error_object[:docUrl] }

    specify { expect(subject.type).to eq error_object[:type] }

    specify { expect(subject.doc_url).to eq error_object[:docUrl] }
  end

  describe "when the error is a message" do
    let(:error_message) { "message" }

    let(:error_type) { "type" }

    subject { Firstclasspostcodes::ResponseError.new(error_message, error_type) }

    specify { expect(subject.type).to eq(error_type) }

    specify { expect(subject.message).to include error_message }

    specify { expect(subject.message).to include error_type }

    specify { expect(subject.doc_url).to include error_type }
  end
end
