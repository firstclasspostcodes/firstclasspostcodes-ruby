# frozen_string_literal: true

require "spec_helper"

describe Firstclasspostcodes do
  subject { Firstclasspostcodes::VERSION }

  specify { expect(subject).to match(/^[0-9]+\.[0-9]+\.[0-9]+$/) }
end
