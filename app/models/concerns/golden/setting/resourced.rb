module Golden
  module Setting
    module Resourced
      extend ActiveSupport::Concern
      included do
      end

      module ClassMethods
        def with_settings
          select("DISTINCT #{self.table_name}.*").
          joins("JOIN `#{settings_table}` ON (#{join_settings_on})")
        end

        def with_settings_for name
          joins("JOIN `#{settings_table}` ON (#{join_settings_on})").
          where("`#{settings_table}`.name = ?", name)
        end

        def without_settings
          joins("LEFT JOIN `#{settings_table}` ON (#{join_settings_on})").
          where("`#{settings_table}`.id IS NULL")
        end

        def without_settings_for name
          without_settings.
          where("`#{settings_table}`.name = ?", name)
        end

        private

        def settings_table
          Golden::Setting::Base.table_name
        end

        def join_settings_on
          [
            "`#{settings_table}`.resource_type = '#{self.base_class.name}'",
            "`#{settings_table}`.resource_id = `#{self.table_name}`.#{self.primary_key}"
          ].join(' AND ')
        end
      end

      def settings
        Golden::Setting::Resource.bind(self)
      end
    end
  end
end
