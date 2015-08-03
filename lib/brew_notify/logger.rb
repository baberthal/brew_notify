require 'brew_notify/options'

module BrewNotify
  module Logger

    class << self

      def logger
        @logger ||= begin
                      require 'lumberjack'
                      Lumberjack::Logger.new(
                        options.fetch(:device) { $stderr },
                        options)
                    end
      end

      def reset_logger
        @logger = nil
      end

      def options
        @options ||= Options.new(
          device: "~/Library/Logs/brew_notify.log",
          level: :info,
          template: ":time - :severity - :message",
          time_format: "%H:%M:%S")
      end

      def options=(options)
        @options = Options.new(options)
      end

      def level=(new_level)
        logger.level = new_level
      end

      def info(message, options = {})
        _logger_message(message, :info, options)
      end

      def warning(message, options = {})
        _logger_message(message, :warn, options)
      end

      def error(message, options = {})
        _logger_message(message, :error, options)
      end

      def debug(message, options = {})
        _logger_message(message, :debug, options)
      end

      def reset_line
        $stderr.print("\r\n")
      end

      private
      def _logger_message(message, method, options = {})
        reset_line if options[:reset]
        logger.send(method, message, options)
      end

    end # class << self
  end # module Logger
end # module BrewNotify
