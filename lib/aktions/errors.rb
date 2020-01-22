# frozen_string_literal: true

module Aktions # :nodoc: #
  # Provides a simple errors object available on a `Aktions::Task` implementing
  # class. This is maintained separately to allow for alternate error-handling
  # scenarios.
  #
  # @!attribute errors [Array] The errors accumulator
  module Errors
    def self.included(base)
      base.prepend ClassMethods
      base.class_eval do
        attr_reader :errors
      end
    end

    module ClassMethods
      # Initializes the implementing class with an array to accumulate errors.
      def initialize
        @errors = []
        super
      end
    end
  end
end
