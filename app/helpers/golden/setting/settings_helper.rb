module Golden
  module Setting
    module SettingsHelper
      def setting_selectable? field_type
        !%w{string boolean}.include? field_type
      end

      def setting_field_types
        Golden::Setting.field_types.map do |key, value|
          next if key.nil? or value.nil?
          [I18n.t(key, scope: 'golden.setting.field_types'), value.to_sym]
        end
      end

      def setting_field_values collection
        return unless collection.present?
        return collection unless collection.respond_to? :id
        options_from_collection_for_select(collection, :id, :to_s, object.value)
      end

      def setting_groups
        Golden::Setting.groups.map do |key, value|
          next if key.nil? or value.nil?
          [I18n.t(key, scope: 'golden.setting.groups'), value.to_s]
        end
      end

      def setting_name name
        I18n.t(name, scope: 'golden.setting.names')
      end

      def settings_nav_tab name, default
        text = I18n.t(name, scope: 'golden.setting.groups')
        nav_tab text, "settings-#{name}", "settings-#{default}"
      end

      def settings_tab_pane name, default, &block
        tab_pane "settings-#{name}", "settings-#{default}", &block
      end

      def skip_setting_group? group
        method = Golden::Setting.skip_groups_method
        skiped = (method and respond_to?(method) and send(method, group))
        group.blank? or skiped
      end

      def skip_setting? setting
        Golden::Setting.skip_settings.include? setting
      end
    end
  end
end
