require 'spec_helper'
require 'brew_notify/checker'

RSpec.describe BrewNotify::Checker, slow: true do
  subject { BrewNotify::Checker.new }
  let(:notifier) { instance_double("BrewNotify::Notifier") }

  describe "brew stuff" do
    it 'knows where the brew executable is' do
      expect(subject.brew_exec).to eq '/usr/local/bin/brew'
    end

    it 'knows how to check for outdated formulae' do
      expect(subject.outdated).to_not be nil
    end
  end
end
