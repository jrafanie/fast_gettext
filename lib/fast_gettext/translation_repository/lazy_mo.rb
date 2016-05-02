require 'fast_gettext/translation_repository/mo'
require 'fast_gettext/lazy_mo_file'
module FastGettext
  module TranslationRepository
    # Responsibility:
    #  - find and store mo files
    #  - load them when data is required for the first time
    #  - provide access to translations in mo files
    class LazyMo < Mo
      protected
      def find_and_store_files(name, options)
        find_files_in_locale_folders(File.join('LC_MESSAGES',"#{name}.mo"), options[:path]) do |locale,file|
          LazyMoFile.new(file)
        end
      end
    end
  end
end
