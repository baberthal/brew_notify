require "brew_notify/notifier"

module BrewNotify
  class Checker
    attr_accessor :brew_exec, :outdated, :notifier
    def initialize(options = {})
      @brew_exec = get_brew_exec
      @outdated ||= brew_outdated.split("\n")
      @notifier ||= BrewNotify::Notifier.detect_notifiers
      notify
    end

    def notify
      if needs_update?
        @notifier.notify(title: "Outdated Brew Formulae:",
                         message: message,
                         icon: 'https://assets-cdn.github.com/images/icons/emoji/unicode/1f37a.png')
      else
        @notifier.notify(title: "All Brew Formulae Up-To-Date!",
                         message: message,
                         icon: 'https://assets-cdn.github.com/images/icons/emoji/unicode/1f37a.png')
      end
    end

    private
    def get_brew_exec
      if osx?
        `which brew`.strip
      else
        exit 1
      end
    end

    def brew_update
      `#{@brew_exec} update`
    end

    def brew_outdated
      brew_update
      `#{@brew_exec} outdated`
    end

    def message
      if needs_update?
        "The following formulae are outdated:\n" + @outdated.join("\n")
      else
        "No formulae are currently out of date."
      end
    end

    def needs_update?
      !@outdated.empty?
    end

    def osx?
      true if RUBY_PLATFORM =~ /darwin/i
    end
  end
end
