# frozen_string_literal: true

require_relative "../has_context_examples"

class AccumulatorItem
  include Actionable::Item

  def call(context)
    step = context.step
    if step == 3
      failure!
      context.processed << :failed
    else
      success!
      context.step = step + 1
      context.processed << :succeeded
    end
  end
end

RSpec.describe Actionable::Queue do
  subject { queue.call(context) }

  let(:queue) { described_class.new(items) }
  let(:items) { nil }
  let(:context) { nil }

   it_behaves_like "has context", described_class.call

  describe ".new" do
    it "rejects nil items" do
      expect(queue.items).to be_empty
    end
  end

  describe "#add" do
    it "adds items to the queue" do
      queue.add AccumulatorItem
      expect(queue.items).to contain_exactly AccumulatorItem
    end
  end

  describe "#call" do
    let(:items) { [AccumulatorItem, AccumulatorItem, AccumulatorItem, AccumulatorItem] }
    let(:context) { { step: 1, processed: [] } }

    it "exits at first failure" do
      expect(subject.context.step).to eq 3
      expect(subject.context.processed).to contain_exactly :succeeded, :succeeded, :failed
    end
  end
end
