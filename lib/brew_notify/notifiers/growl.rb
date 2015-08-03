require 'brew_notify/logger'
begin
  require 'growl'
rescue LoadError => e
  Logger.error e.message
  Logger.debug e.backtrace.join("\n")
end

module BrewNotify
  module Growl

    def notify(options = {})
      ::Growl.notify "#{options[:message]}",
        icon: options[:icon],
        title: options[:title]
    end

    def notifier
      "Growl"
    end
  end
end
