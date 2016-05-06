require 'fast_gettext/lazy_mo_file'

module FastGettext
  # Responsibility:
  #  - abstract po files for Po Repository
  class LazyPoFile < LazyMoFile
    def initialize(file, options={})
      @filename = file
      @options = options
    end

    def load_data(file)
      case file
      when FastGettext::GetText::MOFile
        @data = file
      else
        require 'fast_gettext/po_file'
        @data = FastGettext::PoFile.to_mo_file(file, @options)
      end
      # make_singular_and_plural_available
      @data
    end
  end
end
