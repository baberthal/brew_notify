require "notiffany/notifier"
require "lumberjack"

module BrewNotify
  class Notifier
    def self.connect(options = {})
      @notifier ||= nil
      @logger ||= Lumberjack::Logger.new("~/Library/Logs/brew_notify.log")
      fail "Already connected!" if @notifier
      begin
        opts = options.merge(namespace: "brew_notify", logger: @logger)
        @notifier = Notiffany.connect(opts)
      rescue Notiffany::Notifier::Detected::UnknownNotifier => e
        @logger.error "Failed to setup notification: #{e.message}"
        fail
      end
    end

    def self.disconnect
      @notifier.disconnect
      @notifier = nil
    end

    def self.notify(message, options = {})
      unless @notifier
        connect(notify: true)
      end

      @notifier.notify(message, options)
    rescue RuntimeError => e
      @logger.error "Notification failed for #{@notifier.class.name}: #{e.message}"
      @logger.debug e.backtrace.join("\n")
    end

    def self.turn_on
      @notifier.turn_on
    end

    def self.toggle
      unless @notifier.enabled?
        @logger.error NOTIFICATIONS_DISABLED
        return
      end

      if @notifier.active?
        @logger.info "Turn off notifications"
        @notifier.turn_off
        return
      end

      @notifier.turn_on
    end

  end
end
