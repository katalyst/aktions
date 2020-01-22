# frozen_string_literal: true

require "aktions/context"
require "aktions/errors"
require "aktions/task"
require "aktions/queue"
require "aktions/version"

# Aktions
# =======
#
#
module Aktions
  # Error class which can be raised in the event of call failure.
  class Error < StandardError
  end
end
