# frozen_string_literal: true

require "ostruct"

module Aktions # :nodoc:
  class Context < OpenStruct
    # Constructs a new context instance only if the passed argument is not
    # already the `Aktions::Context`.
    #
    # @param [Hash, Aktions::Context] context The context (data)
    # @return [Aktions::Context] The context instance
    def self.build(context = {})
      self === context ? context : new(context)
    end

    # Sets the context to a successful state.
    def success!
      @_success = true
    end

    # Sets the context to a failure state.
    def failure!
      @_success = false
    end

    # Checks if the action context has succeeded.
    #
    # @return [true, false] The success state of the action context
    def success?
      @_success || false
    end

    # Checks if the action context has failed.
    #
    # @return [true, false] The failure state of the action context
    def failure?
      !success?
    end
  end
end
