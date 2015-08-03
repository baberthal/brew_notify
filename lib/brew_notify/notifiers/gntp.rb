require 'brew_notify/logger'
begin
  require 'ruby_gntp'
rescue LoadError => e
  Logger.error e.message
  Logger.debug e.backtrace.join("\n")
end

module BrewNotify
  module GNTP

    def notify(options = {})
      ::GNTP.notify({
        app_name: 'Brew Notify',
        title: options[:title],
        text: options[:message],
        icon: options[:icon]
      })
    end

    def notifier
      "GNTP"
    end

  end
end
