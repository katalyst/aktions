# frozen_string_literal: true

RSpec.shared_examples "has context" do |context|
  it { expect(context).to respond_to :success! }
  it { expect(context).to respond_to :failure! }
  it { expect(context).to respond_to :success? }
  it { expect(context).to respond_to :failure? }

  describe "#success!" do
    it "sets success state" do
      context.success!
      expect(context).to be_success
    end
  end

  describe "#failure!" do
    it "sets failure state" do
      context.failure!
      expect(context).to be_failure
    end
  end
end
