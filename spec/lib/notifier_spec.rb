require 'spec_helper'
require 'brew_notify/notifier'
require 'brew_notify/notifiers/gntp'
require 'brew_notify/notifiers/growl'
require 'brew_notify/notifiers/terminal_notifier'


RSpec.describe BrewNotify::Notifier do
  let(:gntp) { instance_double("BrewNotify::GNTP") }
  let(:growl) { instance_double("BrewNotify::Growl") }
  let(:terminal_notifier) { instance_double("BrewNotify::TerminalNotifier") }
  let(:logger) { instance_spy("BrewNotify::Logger") }

  before do
    allow(BrewNotify::Logger).to receive(:new).and_return(logger)
  end

  after do
    BrewNotify::Notifier.instance_variable_set(:@notifier, nil)
  end

  describe "#new" do
    context 'with options' do
      before do
        allow(BrewNotify::GNTP).to receive(:new).and_return(gntp)
        allow(BrewNotify::Growl).to receive(:new).and_return(growl)
        allow(BrewNotify::TerminalNotifier).to receive(:new).and_return(terminal_notifier)
      end

      context 'with :gntp as option' do
        subject { BrewNotify::Notifier.new(notifier: :gntp) }

        it 'initializes a new BrewNotify::GNTP' do
          expect(subject.notifier).to be gntp
        end

        it 'has a logger' do
          expect(subject.logger).to be logger
        end

      end

      context 'with :growl as option' do
        subject { BrewNotify::Notifier.new(notifier: :growl) }

        it 'initializes a new BrewNotify::Growl' do
          expect(subject.notifier).to be growl
        end

        it 'has a logger' do
          expect(subject.logger).to be logger
        end
      end

      context 'with :terminal_notifier as option' do
        subject { BrewNotify::Notifier.new(notifier: :terminal_notifier) }

        it 'initializes a new BrewNotify::TerminalNotifier' do
          expect(subject.notifier).to be terminal_notifier
        end

        it 'has a logger' do
          expect(subject.logger).to be logger
        end
      end
    end

    context 'without options' do
      context 'when ruby_gntp is available' do
        before do
          allow(BrewNotify::GNTP).to receive(:new).and_return(gntp)
        end

        it 'tries first to use gntp' do
          subj = BrewNotify::Notifier.new
          expect(subj.notifier).to be gntp
        end
      end

      context 'when ruby_gntp is not available' do
        before do
          allow(BrewNotify::GNTP).to receive(:new).and_raise(LoadError, "an error")
        end

        it 'tries to use gntp and raises an error' do
          expect{ BrewNotify::Notifier.new }.to raise_error(LoadError)
          expect(logger).to receive(:error)
        end
      end


    end
  end
end

