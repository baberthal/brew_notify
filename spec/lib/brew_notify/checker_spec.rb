require 'spec_helper'
require 'brew_notify/checker'
require 'brew_notify/notifiers/gntp'
require 'brew_notify/notifiers/growl'
require 'brew_notify/notifiers/terminal_notifier'

RSpec.describe BrewNotify::Checker do
  context 'on OSX' do
    let(:checker) { BrewNotify::Checker.new }
    let(:dummy) { instance_double("BrewNotify::Notifier") }

    describe "brew stuff" do
      it 'knows where the brew executable is' do
        expect(checker.brew_exec).to eq '/usr/local/bin/brew'
      end

      it 'knows how to check for outdated formulae' do
        expect(checker.outdated).to_not be nil
      end
    end

    describe "#notify" do
      shared_examples "a notifier" do
        it 'notifies when outdated formulae exist' do
          pending
          outdated = ["openssl", "a formula", "another formula"]
          checker.outdated = outdated
          checker.notify
          expect(checker.notifier).to receive(:notify).
            with({title: "Outdated Brew Formulae:",
                  message: "The following formulae are outdated:\n#{outdated.join("\n")}"})
        end
      end

      describe "gntp" do
        let(:dummy) { BrewNotify::Notifier.new(notifier: :gntp) }
        # let(:dummy) { double(gntp) }

        before :each do
          # allow(dummy).to receive(:notify).and_return(:nil)
          checker.notifier = dummy
        end

        it_behaves_like 'a notifier'
      end
    end
  end
end
