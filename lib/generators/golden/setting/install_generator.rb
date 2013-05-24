require 'active_record/migration'

class Golden::Setting::InstallGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  # argument :name, type: :string, default: 'setting'

  def self.next_migration_number dirname
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  def generate_migration
    file = 'create_golden_settings.rb'
    migration_template file, File.join('db/migrate', class_path, file)
  end

  def generate_model
    # generate :model, name, '--skip-migration'
    file = 'setting.rb'
    log :model, file
    template file, File.join('app/models', class_path, "#{file_name}.rb"), verbose: false
  end

  def inject_javascript
    file = 'app/assets/javascripts/application.js'
    log :javascripts, 'application.js'
    sentinel = "//= require_tree .\n"
    insert_into_file file, before: sentinel, verbose: false do
      "//= require golden/setting/settings\n"
    end
  end

  def inject_stylesheet
    file = 'app/assets/stylesheets/application.css'
    log :stylesheets, 'application.css'
    sentinel = " *= require_self\n"
    insert_into_file file, before: sentinel, verbose: false do
      " *= require golden/setting/settings\n"
    end
  end

  def generate_initializer
    file = 'golden_setting.rb'
    log :initializer, file
    template file, File.join('config/initializers', class_path, file), verbose: false
  end

  def add_locales_path
    file = 'config/application.rb'
    sentinel = "# config.i18n.default_locale = :de\n"
    insert_into_file file, after: sentinel do
      "    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]\n"
    end
  end

  def generate_locales
    files = %w{settings.en.yml settings.zh-TW.yml}
    files.each do |file|
      log :locales, "golden/#{file}"
      template file, File.join('config/locales/golden', class_path, file), verbose: false
    end
  end

  def inject_routes
    route "mount Golden::Setting::Engine, at: '/'\n"
  end

  def inject_controller
    file = 'app/controllers/application_controller.rb'
    sentinel = "protect_from_forgery with: :exception\n"
    insert_into_file file, after: sentinel do
      "  alias_method :authenticate_session!, :authenticate_user!\n"
    end
  end

  def inject_layout
    file = 'app/views/layouts/application.html.erb'
    sentinel = "<%= yield %>\n"
    gsub_file file, "<%= yield %>\n" do |match|
      %Q{<div class="<%= controller_name %>"><%= yield %></div>\n}
    end
  end
end
