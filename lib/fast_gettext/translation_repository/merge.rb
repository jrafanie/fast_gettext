require 'fast_gettext/translation_repository/po'

module FastGettext
  module TranslationRepository
    # Responsibility:
    #  - merge data from multiple repositories into one hash structure
    #  - can be used instead of searching for translations in multiple domains
    #  - requires reload when current locale is changed
    class Merge < Base
      SUPPORTED_REPO_TYPES = [
        FastGettext::TranslationRepository::Mo,
        FastGettext::TranslationRepository::Po
      ]

      def initialize(name, options={})
        clear
        super(name, options)
      end

      def available_locales
        @repositories.map { |r| r.available_locales }.flatten.uniq
      end

      def pluralisation_rule
        @repositories.each do |r|
          result = r.pluralisation_rule and return result
        end
        nil
      end

      def plural(*keys)
        @repositories.each do |r|
          result = r.plural(*keys)
          return result unless result.compact.empty?
        end
        []
      end

      def reload
        @data = {}
        @repositories.each do |r|
          load_repo(r)
        end
        super
      end

      def add_repo(repo)
        raise "Unsupported repository" unless SUPPORTED_REPO_TYPES.find {|c| repo.is_a?(c) }
        @repositories << repo
        load_repo(repo)
        true
      end

      def [](key)
        @data[key]
      end

      def clear
        @repositories = []
        @data = {}
      end

      protected

      def load_repo(r)
        r.reload
        @data = r.send('current_translations').data.merge(@data)
      end
    end
  end
end
