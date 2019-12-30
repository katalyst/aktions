# frozen_string_literal: true

require_relative "../has_context_examples"

class TestTask
  include Aktions::Task
end

RSpec.describe Aktions::Task do
  it_behaves_like "has context", TestTask.call

  describe ".call" do
    subject { TestTask.call }

    it { expect(subject).to be_failure }
  end
end
