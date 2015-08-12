require 'brew_notify/logger'

module BrewNotify
  class Notifier
    SUPPORTED_NOTIFIERS = ['gntp', 'terminal_notifier', 'growl']
    def self.detect_notifiers
      SUPPORTED_NOTIFIERS.each do |n|
        begin
          return BrewNotify::Notifier.new(notifier: n.to_sym)
        rescue Exception => e
          Logger.error "Initialization failed for #{n}: #{e.message}"
          Logger.debug e.backtrace.join("\n")
          next
        end
      end
    end

    def initialize(options = {})
      if options[:notifier]
        set_preferred_notifier(options)
      else
        BrewNotify::Notifier.detect_notifiers
      end
    end

    private
    def set_preferred_notifier(options = {})
      case options[:notifier]
      when :gntp
        require "brew_notify/notifiers/gntp"
        extend BrewNotify::GNTP
      when :growl
        require "brew_notify/notifiers/growl"
        extend BrewNotify::Growl
      when :terminal_notifier
        require "brew_notify/notifiers/terminal_notifier"
        extend BrewNotify::TerminalNotifier
      else raise ArgumentError, 'Notifier not recognized'
      end
    end

  end
end
