# frozen_string_literal: true

require "forwardable"

module Aktions # :nodoc:
  # `Aktions::Task` allows business logic to be extracted from the main flow
  # to be processed in isolation.
  #
  # The module provides a single method `call`, available on both the class and
  # the instance, which accepts a hash or `Aktions::Context` instance as a
  # parameter. The class version of the method is a wrapper for the instance
  # method with the default constructor params. This allows implementing
  # classes to handle dependency injection without making any assumptions.
  #
  # @example
  #   class MyClass
  #     include Aktions::Task
  #
  #     def initialize(service: MyServiceClass)
  #       @service = service
  #     end
  #
  #     def call
  #       # do something with @service here
  #     end
  #   end
  #
  #   MyClass.call # @service instance variable is automatically initialized
  module Task
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
      # @param [Aktions::Context, Hash] context The contextual arguments
      # @return [Aktions::Task] The implementing class instance
      def call(context = {})
        new.call(context)
      end
    end

    module InstanceMethods
      # Main entry point. The implementing class should define this method, which
      # is then wrapped by this call.
      #
      # Since this method wraps the implementing class, it disallows the use of
      # named parameters in method definitions. To ensure that the context has
      # the required parameters, use (@see #expect!) or (@see #expect).
      #
      # @param [Aktions::Context, Hash] context The contextual arguments
      # @return [Aktions::Task] The implementing class instance
      def call(context = {})
        @context = Context.build(context)
        @_result = super(@context) if defined?(super)
        self
      end

      protected

      # Checks the context for the expected parameters, raising `Aktions::Error`
      # in the event of missing properties. The call is automatically failed in
      # this case.
      #
      # @param [Array(Symbol, String)] properties The properties to which the context must respond
      # @raise [Aktions::Error] if expectations are not met
      def expect!(*properties)
        unless properties.reduce(true) { |acc, p| acc && @context.respond_to?(p) }
          failure!
          raise Aktions::Error, "One of the following context expectations was not met: #{properties.join(', ')}"
        end
      end

      # Checks the expected properties on the context.
      #
      # @param [Array(Symbol, String)] properties The expected properties of the context
      #
      # @return [true, false] Whether expectations are met
      def expect(*properties)
        expect!(properties)
        true
      rescue Aktions::Errors
        false
      end
    end
  end
end
