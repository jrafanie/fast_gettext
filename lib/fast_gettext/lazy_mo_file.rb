require 'fast_gettext/vendor/mofile'
module FastGettext
  # Responsibility:
  #  - abstract mo files with lazy loading for Mo Repository
  class LazyMoFile < MoFile
    def initialize(file)
      @filename = file
    end

    def [](key)
      data[key]
    end

    def data
      load_data(@filename) if @data.nil?
      @data
    end

    private

    def load_data(file)
      if file.is_a? FastGettext::GetText::MOFile
        @data = file
      else
        @data = FastGettext::GetText::MOFile.open(file, "UTF-8")
      end
      make_singular_and_plural_available
    end
  end
end
