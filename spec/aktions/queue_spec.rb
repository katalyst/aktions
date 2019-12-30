# frozen_string_literal: true

require_relative "../has_context_examples"

class AccumulatorTask
  include Aktions::Task

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

RSpec.describe Aktions::Queue do
  subject { queue.call(context) }

  let(:queue) { described_class.new(tasks) }
  let(:tasks) { nil }
  let(:context) { nil }

   it_behaves_like "has context", described_class.call

  describe ".new" do
    it "rejects nil items" do
      expect(queue.tasks).to be_empty
    end
  end

  describe "#add" do
    it "adds items to the queue" do
      queue.add AccumulatorTask
      expect(queue.tasks).to contain_exactly AccumulatorTask
    end
  end

  describe "#call" do
    let(:tasks) { [AccumulatorTask, AccumulatorTask, AccumulatorTask, AccumulatorTask] }
    let(:context) { { step: 1, processed: [] } }

    it "exits at first failure" do
      expect(subject.context.step).to eq 3
      expect(subject.context.processed).to contain_exactly :succeeded, :succeeded, :failed
    end
  end
end
