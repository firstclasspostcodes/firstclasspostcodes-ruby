RSpec.shared_examples "a class that emits events" do
  specify { expect(subject).to respond_to(:on) }

  specify { expect(subject).to respond_to(:off) }

  specify { expect(subject).to respond_to(:emit) }

  specify { expect(subject).to respond_to(:events) }
end