require 'thor/core_ext/hash_with_indifferent_access'

module BrewNotify
  # A class that holds options. Can be instantiated with defaults
  # Borrowed heavily from Guard::Options
  #
  class Options < Thor::CoreExt::HashWithIndifferentAccess
    # Initializes a BrewNotify::Options object. `default_opts` is merged into
    # `opts`
    #
    # @param [Hash] opts the options
    # @param [Hash] default_opts
    #
    def initialize(opts = {}, default_opts = {})
      super(default_opts.merge(opts || {}))
    end
  end
end
