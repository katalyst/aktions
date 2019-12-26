# frozen_string_literal: true

require 'spec/spec_helper'
require 'actionable/context'

RSpec.describe Actionable::Context, type: :class do
  let(:params) { { a: 'one', b: 'two' } }
  subject(:context) { Actionable::Context.new(params) }

  describe '.new' do
    it 'creates a new context from the parameters' do
      expect(context).to have_attributes(params)
    end
  end

  describe '#success!' do
    expect(context).not_to be_success
    context.success!
    expect(context).to be_success
  end
end
