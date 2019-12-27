# frozen_string_literal: true

require_relative "../has_context_examples"

class TestItem
  include Actionable::Item
end

RSpec.describe Actionable::Item do
  it_behaves_like "has context", TestItem.call

  describe ".call" do
    subject { TestItem.call }

    it { expect(subject).to be_failure }
  end
end
