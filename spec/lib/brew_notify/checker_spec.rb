require 'spec_helper'
require 'brew_notify/checker'

RSpec.describe BrewNotify::Checker do
  subject { BrewNotify::Checker.new }

  describe "brew stuff" do
    it 'knows where the brew executable is' do
      expect(subject.brew_exec).to eq '/usr/local/bin/brew'
    end

    it 'knows how to check for outdated formulae' do
      expect(subject.outdated).to_not be nil
    end
  end

  describe "#notify", focus: true do
    let(:notifier) { instance_double("BrewNotify::Notifier") }
    let(:gntp) { class_double("::GNTP") }

    before do
      allow(BrewNotify::Notifier).to receive(:new).and_return(notifier)
    end

    context 'when formulae are outdated' do
      let(:outdated) { ['openssl', 'foo', 'bar'] }
      it 'notifies when outdated formulae exist' do
        subject.outdated = outdated
        subject.notify
        expect(notifier).to receive(:notify).
          with({title: "Outdated Brew Formulae:",
               message: "The following formulae are outdated:\n#{outdated.join("\n")}"})
      end
    end

  end
end
