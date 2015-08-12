require 'spec_helper'
require 'brew_notify/os'

# Dummy Class to extend OS with
class DummyClass
  include BrewNotify::OS
end

RSpec.describe BrewNotify::OS do
  context 'when the platform is OSX' do
    before :all do
      unless RUBY_PLATFORM =~ /darwin/i
        @platform = RUBY_PLATFORM
        RUBY_PLATFORM = 'darwin'
      end
    end

    after :all do
      if @platform
        RUBY_PLATFORM = @platform
      end
    end

    describe 'class_methods' do
      let(:dummy) { DummyClass }
      it 'has the method osx? available' do
        expect(dummy.osx?).to be_truthy
      end

      it 'has the method check_for_osx available' do
        expect(dummy.check_for_osx).to be nil
      end
    end
  end

  context 'when the platform is not OSX' do
    before :all do
      if RUBY_PLATFORM =~ /darwin/i
        @platform = RUBY_PLATFORM
        RUBY_PLATFORM = 'linux'
      end
    end

    after :all do
      if @platform
        RUBY_PLATFORM = @platform
      end
    end

    describe 'class_methods' do
      let(:dummy) { DummyClass }
      it 'has the method osx? available' do
        expect(dummy.osx?).to be_falsy
      end

      it 'has the method check_for_osx available' do
        begin
          dummy.check_for_osx
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end
    end
  end
end
