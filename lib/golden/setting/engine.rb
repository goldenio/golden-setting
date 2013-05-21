module Golden
  module Setting
    class Engine < ::Rails::Engine
      isolate_namespace Golden::Setting
      engine_name :golden_setting

      config.autoload_paths += [
        root.join('app', 'models', 'concerns').to_s
      ]

      config.after_initialize do
        Golden::Setting::Base.table_name = Golden::Setting.table_name
      end
    end
  end
end
