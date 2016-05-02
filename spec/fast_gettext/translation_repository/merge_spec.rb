require "spec_helper"

describe 'FastGettext::TranslationRepository::LazyMo' do
  before do
    @rep = FastGettext::TranslationRepository.build('test', :type => :merge)
    @rep.is_a?(FastGettext::TranslationRepository::Merge).should == true

    mo_rep = FastGettext::TranslationRepository.build('test', :path=>File.join('spec', 'locale'), :type => :mo)
    @rep.add_repo(mo_rep)
  end

  it "can be built" do
    @rep.available_locales.sort.should == ['de','en','gsw_CH']
  end

  it "can translate" do
    FastGettext.locale = 'de'
    @rep['car'].should == 'Auto'
  end

  it "can pluralize" do
    FastGettext.locale = 'de'
    @rep.plural('Axis','Axis').should == ['Achse','Achsen']
  end

  describe "#add_repo" do
    it "accepts mo repository" do
      mo_rep = FastGettext::TranslationRepository.build('test', :path=>File.join('spec', 'locale'), :type => :mo)
      @rep.add_repo(mo_rep).should == true
    end

    it "accepts po repository" do
      po_rep = FastGettext::TranslationRepository.build('test', :path=>File.join('spec', 'locale'), :type => :po)
      @rep.add_repo(po_rep).should == true
    end

    it "raises exeption for other repositories" do
      base_rep = FastGettext::TranslationRepository.build('test', :path=>File.join('spec', 'locale'), :type => :base)
      lambda { @rep.add_repo(base_rep) }.should raise_error(RuntimeError)
    end
  end

  describe "#reload" do
    before do
      mo_file = FastGettext::MoFile.new('spec/locale/de/LC_MESSAGES/test2.mo')
      empty_mo_file = FastGettext::MoFile.empty

      FastGettext::MoFile.stub(:new).and_return(empty_mo_file)
      FastGettext::MoFile.stub(:new).with('spec/locale/de/LC_MESSAGES/test.mo').and_return(mo_file)
    end

    it "can reload" do
      FastGettext.locale = 'de'

      @rep['Untranslated and translated in test2'].should be_nil

      @rep.reload

      @rep['Untranslated and translated in test2'].should == 'Translated'
    end

    it "returns true" do
      @rep.reload.should == true
    end
  end

  it "has access to the mo repositories pluralisation rule" do
    FastGettext.locale = 'en'
    rep = FastGettext::TranslationRepository.build('plural_test',:path=>File.join('spec','locale'))
    rep['car'].should == 'Test'#just check it is loaded correctly
    rep.pluralisation_rule.call(2).should == 3
  end

  it "can work in SAFE mode" do
    pending_if RUBY_VERSION > "2.0" do
      `ruby spec/cases/safe_mode_can_handle_locales.rb 2>&1`.should == 'true'
    end
  end
end
