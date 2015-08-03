$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'brew_notify'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]

  config.order = :random
end
