require 'spec_helper'
require 'brew_notify/notifier'
require 'brew_notify/notifiers/gntp'
require 'brew_notify/notifiers/growl'
require 'brew_notify/notifiers/terminal_notifier'
require 'lumberjack'


RSpec.describe BrewNotify::Notifier do
  describe "#new" do
    context 'with options' do
      context 'with :gntp as option' do
        subject { BrewNotify::Notifier.new(notifier: :gntp) }

        it 'extends BrewNotify::GNTP' do
          expect(subject.notifier).to eq "GNTP"
        end

        it 'can send notifications' do
          expect(::GNTP).to receive(:notify).
            with(app_name: "Brew Notify", title: "A", text: "B", icon: nil)
          subject.notify(title: "A", message: "B")
        end

      end

      context 'with :growl as option' do
        subject { BrewNotify::Notifier.new(notifier: :growl) }

        it 'initializes a new BrewNotify::Growl' do
          expect(subject.notifier).to eq "Growl"
        end

        it 'can send notifications' do
          expect(::Growl).to receive(:notify).
            with("B", { title: "A", icon: nil })
          subject.notify(title: "A", message: "B")
        end

      end

      context 'with :terminal_notifier as option' do
        subject { BrewNotify::Notifier.new(notifier: :terminal_notifier) }

        it 'initializes a new BrewNotify::TerminalNotifier' do
          expect(subject.notifier).to eq "Terminal Notifier"
        end

        it 'can send notifications' do
          expect(::TerminalNotifier).to receive(:notify).
            with("B", title: "A", icon: nil)
          subject.notify(title: "A", message: "B")
        end

      end
    end
  end

  describe 'self.detect_notifiers' do
    context 'when ruby_gntp is available' do
      it 'tries first to use gntp' do
        subj = BrewNotify::Notifier.detect_notifiers
        expect(subj.notifier).to eq "GNTP"
      end
    end
  end
end

