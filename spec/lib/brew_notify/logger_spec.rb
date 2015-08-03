require 'spec_helper'
require 'brew_notify/logger'
require 'lumberjack'

RSpec.describe BrewNotify::Logger do
  let(:logger) { instance_double("Lumberjack::Logger") }

  before do
    allow(Lumberjack::Logger).to receive(:new).and_return(logger)

    allow(BrewNotify::Logger).to receive(:info).and_call_original
    allow(BrewNotify::Logger).to receive(:warning).and_call_original
    allow(BrewNotify::Logger).to receive(:error).and_call_original
    allow(BrewNotify::Logger).to receive(:debug).and_call_original

    allow(logger).to receive(:info)
    allow(logger).to receive(:warn)
    allow(logger).to receive(:error)
    allow(logger).to receive(:debug)

    allow($stderr).to receive(:print)
  end

  after do
    BrewNotify::Logger.reset_logger

    BrewNotify::Logger.options = {
      level: :info,
      device: $stderr,
      template: ":time - :severity - :message",
      time_format: "%H:%M:%S"
    }
  end

  describe "#logger" do
    it 'returns the logger instance' do
      expect(BrewNotify::Logger.logger).to be(logger)
    end

    it 'sets the logger device' do
      expect(Lumberjack::Logger).to receive(:new).
        with($stderr, BrewNotify::Logger.options)

      BrewNotify::Logger.logger
    end
  end

  describe "#options=" do
    it 'sets the logger options' do
      BrewNotify::Logger.options = { hi: :ho }
      expect(BrewNotify::Logger.options[:hi]).to eq :ho
    end
  end

  describe "#info" do
    it 'resets the line with the :reset options' do
      expect(BrewNotify::Logger).to receive :reset_line
      BrewNotify::Logger.info("Info", reset: true)
    end

    it 'logs the message with the info severity' do
      expect(BrewNotify::Logger.logger).to receive(:info).with("Info", {})
      BrewNotify::Logger.info "Info"
    end
  end

  describe "#warning" do
    it "resets the line with the :reset option" do
      expect(BrewNotify::Logger).to receive :reset_line
      BrewNotify::Logger.warning("Warning", reset: true)
    end

    it "logs the message to with the warn severity" do
      expect(BrewNotify::Logger.logger).to receive(:warn).
        with("Warning", {})

      BrewNotify::Logger.warning "Warning"
    end

  end

  describe "#error" do
    it "resets the line with the :reset option" do
      expect(BrewNotify::Logger).to receive :reset_line
      BrewNotify::Logger.error("Error message", reset: true)
    end

    it "logs the message to with the error severity" do
      expect(BrewNotify::Logger.logger).to receive(:error).
        with("Error message", {})

      BrewNotify::Logger.error "Error message"
    end
  end

end
