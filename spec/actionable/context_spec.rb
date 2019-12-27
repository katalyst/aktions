# frozen_string_literal: true

require_relative "../has_context_examples"

RSpec.describe Actionable::Context do
  subject(:context) { described_class.new(params) }

  let(:params) { { a: "one", b: "two" } }

  describe ".new" do
    it "creates a new context from the parameters" do
      expect(context).to have_attributes(params)
    end

    it "is not successful by default" do
      expect(context).not_to be_success
    end

    context "with no params" do
      let(:params) { nil }

      it { expect(context).to have_attributes({}) }
    end
  end

  it_behaves_like "has context", described_class.new
end
