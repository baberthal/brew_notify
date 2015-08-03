module BrewNotify
  class Notifier
    attr_reader :notifier, :logger

    def initialize(options = {})
      @logger = Logger.new('~/Library/Logs/brew_notify.log')
      if options[:notifier]
        set_preferred_notifier(options)
      else
        detect_notifiers
      end
    end

    private
    def set_preferred_notifier(options = {})
      case options[:notifier]
      when :gntp
        require "brew_notify/notifiers/gntp"
        @notifier = BrewNotify::GNTP.new()
      when :growl
        require "brew_notify/notifiers/growl"
        @notifier = BrewNotify::Growl.new()
      when :terminal_notifier
        require "brew_notify/notifiers/terminal_notifier"
        @notifier = BrewNotify::TerminalNotifier.new()
      end
    end

    def detect_notifiers
      begin
        require "brew_notify/notifiers/gntp"
        @notifier = BrewNotify::GNTP.new()
      rescue LoadError => e
        @logger.error(e.message)
        raise
      end
    end
  end
end
