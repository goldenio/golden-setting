module Golden
  module Setting
    module Cache
      extend ActiveSupport::Concern
      included do
        after_create :rewrite_cache
        after_update :rewrite_cache
        after_destroy :delete_cache
      end

      module ClassMethods
        def fetch_cache name
          if block_given?
            ::Rails.cache.fetch("setting:#{name}") { yield }
          else
            ::Rails.cache.fetch "setting:#{name}"
          end
        end

        def rewrite_cache name, value
          ::Rails.cache.write "setting:#{name}", value
        end

        def delete_cache name
          ::Rails.cache.delete "setting:#{name}"
        end

        def [] name
          obj = fetch_cache(name) { super(name) }
          obj || defaults[name.to_sym]
        end

        def []= name, value
          if self[name] != value
            super name, value
          end
        end

        def is_true? name
          fetch_cache("#{name}?") { super(name) }
        end
      end

      def rewrite_cache
        self.class.rewrite_cache name, value
        self.class.rewrite_cache "#{name}?", self.class.base_class.is_true?(name)
      end

      def delete_cache
        self.class.delete_cache name
        self.class.delete_cache "#{name}?"
      end
    end
  end
end
