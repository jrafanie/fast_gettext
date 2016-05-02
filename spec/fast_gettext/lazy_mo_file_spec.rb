# encoding: utf-8
require "spec_helper"
require 'fast_gettext/lazy_mo_file'

de_file = File.join('spec','locale','de','LC_MESSAGES','test.mo')

describe FastGettext::LazyMoFile do
  let(:de) { FastGettext::LazyMoFile.new(de_file) }

  before :all do
    File.exist?(de_file).should == true
  end

  it "doesn't load the file when new instance is created" do
    FastGettext::GetText::MOFile.should_not_receive(:open)
    FastGettext::LazyMoFile.new(de_file)
  end

  it "loads the file when a translation is touched for the first time" do
    data = FastGettext::GetText::MOFile.open(de_file, "UTF-8")
    FastGettext::GetText::MOFile.should_receive(:open).once.and_return(data)

    de['car']
    de['car']
  end

  it "loads the file when data is touched for the first time" do
    data = FastGettext::GetText::MOFile.open(de_file, "UTF-8")
    FastGettext::GetText::MOFile.should_receive(:open).once.and_return(data)

    de.data
    de.data
  end

  it "parses a file" do
    de['car'].should == 'Auto'
  end

  it "stores untranslated values as nil" do
    de['Untranslated'].should == nil
  end

  it "finds pluralized values" do
    de.plural('Axis','Axis').should == ['Achse','Achsen']
  end

  it "returns empty array when pluralisation could not be found" do
    de.plural('Axis','Axis','Axis').should == []
  end

  it "can access plurals through []" do
    de['Axis'].should == 'Achse' #singular
  end

  it "can successfully translate non-ASCII keys" do
    de["Umläüte"].should == "Umlaute"
  end
end
