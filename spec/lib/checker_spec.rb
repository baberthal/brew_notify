require 'spec_helper'
require 'brew_notify/checker'

RSpec.describe BrewNotify::Checker, slow: true do
  subject { BrewNotify::Checker.new }
  let(:notifier) { class_double("BrewNotify::Notifier") }

  before do
    allow(BrewNotify::Notifier).to receive(:connect)
  end


  describe "brew stuff" do
    it 'knows where the brew executable is' do
      expect(subject.brew_exec).to eq '/usr/local/bin/brew'
    end

    it 'knows how to check for outdated formulae' do
      expect(subject.outdated).to_not be nil
    end
  end

  describe "notifying" do
    before do
      @outdated = ['openssl', 'ruby']
      subject.outdated = @outdated
      allow(notifier).to receive(:notify)
    end

    it 'can send a message with the notifier' do
      subject.send_notification
      expect(notifier).to receive(:notify)
    end

  end
end
