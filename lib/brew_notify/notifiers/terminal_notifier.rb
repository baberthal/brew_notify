require 'brew_notify/logger'
begin
  require 'terminal-notifier'
rescue LoadError => e
  Logger.error e.message
  Logger.debug e.backtrace.join("\n")
end

module BrewNotify
  module TerminalNotifier

    def notify(options = {})
      ::TerminalNotifier.notify(options[:message],
                                title: options[:title],
                                icon: options[:icon])
    end

    def notifier
      "Terminal Notifier"
    end

  end
end
