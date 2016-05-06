require 'fast_gettext/translation_repository/base'
require 'fast_gettext/translation_repository/mo'
require 'fast_gettext/lazy_po_file'
module FastGettext
  module TranslationRepository
    # Responsibility:
    #  - find and store mo files
    #  - load them when data is required for the first time
    #  - provide access to translations in mo files
    class LazyPo < Mo
      protected
      def find_and_store_files(name, options)
        find_files_in_locale_folders("#{name}.po", options[:path]) do |locale,file|
          LazyPoFile.new(file, options)
        end
      end
    end
  end
end

