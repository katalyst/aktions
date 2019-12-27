# frozen_string_literal: true

require "forwardable"

module Actionable
  module Item
    def self.included(base)
      base.extend Forwardable
      base.extend ClassMethods
      base.prepend InstanceMethods
      base.class_eval do
        attr_reader :context
        def_delegators :@context, :success!, :failure!, :success?, :failure?
      end
    end

    module ClassMethods
      # Invokes the action with the default constructor arguments.
      #
      # @param [Actionable::Context, Hash] context The contextual arguments
      # @return [Actionable] The implementing class instance
      def call(context = {})
        new.call(context)
      end
    end

    module InstanceMethods
      # Main entry point. The implementing class should define this method, which
      # is then wrapped by this call.
      #
      # @param [Actionable::Context, Hash] context The contextual arguments
      # @return [Actionable] The implementing class instance
      def call(context = {})
        @context = Context.build(context)
        @_result = super(@context) if defined?(super)
        self
      end
    end
  end
end
