require "brew_notify/notifier"

module BrewNotify
  class Checker
    attr_accessor :brew_exec, :outdated, :notifier
    def initialize(options = {})
      @brew_exec = get_brew_exec
      @outdated ||= brew_outdated.split("\n")
      @notifier ||= BrewNotify::Notifier.connect(options)
    end

    def send_notification
      if needs_update?
        BrewNotify::Notifier.send(:notify,
                                  message,
                                  { title: "Outdated Brew Formulae:" })
      else
        BrewNotify::Notifier.send(:notify,
                                  message,
                                  { title: "All Brew Formulae Up-To-Date!" })
      end
      BrewNotify::Notifier.disconnect
    end

    private
    def get_brew_exec
      `which brew`.strip
    end

    def brew_update
      `#{@brew_exec} update`
    end

    def brew_outdated
      brew_update
      `#{@brew_exec} outdated`
    end

    def needs_update?
      @outdated.length > 0 && @outdated.first != ''
    end

    def message
      if needs_update?
        "The following formulae are outdated:\n" + @outdated.join("\n")
      else
        "No formulae are currently out of date."
      end
    end
  end
end
