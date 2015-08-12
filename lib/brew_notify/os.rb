module BrewNotify
  module OS

    def self.included base
      base.extend ClassMethods
    end

    def osx?
      RUBY_PLATFORM =~ /darwin/i
    end

    module ClassMethods
      def osx?
        RUBY_PLATFORM =~ /darwin/i
      end

      def check_for_osx
        unless osx?
          puts "This software is meant to be run on a Mac. Sorry..."
          exit 1
        end
      end
    end
  end
end
