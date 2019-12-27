# frozen_string_literal: true

module Actionable # :nodoc:
  # `Actionable::Queue` accepts a list of classes to be invoked in order. These
  # passed object (either instance or class) must respond to the method `call`,
  # which takes an optional context parameter and returns `self`, and a method
  # `#success?` which returns the result of the computation.
  #
  # @example
  #   queue = Actionable::Queue.new(Item1, Item2.new(dependency: service))
  #   queue.call(context)
  #   if queue.success?
  #     # success state
  #   else
  #     # failure state
  #   end
  #
  # The context is passed between items, so if later steps have dependencies on
  # the results of earlier computations, these can be appended to the context
  # to be made available.
  class Queue
    include Item

    attr_reader :items

    # Initializes a new `Actionable::Queue` with the specified list of classes
    #
    # @param [Array] args The list of classes/instances to process
    def initialize(*args)
      @items = []
      add(args)
    end

    # Adds additional items to the queue to be processed. Helpful if the queue
    # needs to be constructed conditionally.
    #
    # @param [Array] args The additional steps to be added
    def add(*args)
      @items += args
      @items.flatten!
      @items.compact!
    end

    # Processes the queued items in order. Exits the processing if any step
    # fails.
    #
    # @param [Actionable::Context, Hash] context The context arguments for the steps in the queue
    # @return [Actionable::Queue] The evaluated instance
    def call(context = {})
      success = items.reduce(true) do |acc, item|
        break unless acc && item.call(context).success?

        acc
      end

      update!(success)
    end

    private

    def update!(state)
      if state
        success!
      else
        failure!
      end
    end
  end
end
