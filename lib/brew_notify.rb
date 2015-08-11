require "brew_notify/version"
require "brew_notify/checker"
require "thor"

module BrewNotify
  class MyCLI < Thor
    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "Hello #{name}"
    end
  end
end
