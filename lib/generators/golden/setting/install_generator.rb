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

  def inject_javascript_js
    file = 'app/assets/javascripts/application.js'
    return unless File.exists? file
    log :javascripts, 'application.js'
    sentinel = "//= require_tree .\n"
    insert_into_file file, before: sentinel, verbose: false do
      "//= require golden/setting/settings\n"
    end
  end

  def inject_javascript_coffee
    file = 'app/assets/javascripts/application.js.coffee'
    return unless File.exists? file
    log :javascripts, 'application.js.coffee'
    sentinel = "#= require_tree .\n"
    insert_into_file file, before: sentinel, verbose: false do
      "#= require golden/setting/settings\n"
    end
  end

  def inject_stylesheet_css
    file = 'app/assets/stylesheets/application.css'
    return unless File.exists? file
    log :stylesheets, 'application.css'
    sentinel = " *= require_self\n"
    insert_into_file file, before: sentinel, verbose: false do
      " *= require golden/setting/settings\n"
    end
  end

  def inject_stylesheet_sass
    file = 'app/assets/stylesheets/application.css.sass'
    return unless File.exists? file
    log :stylesheets, 'application.css.sass'
    sentinel = "//= require_self\n"
    insert_into_file file, before: sentinel, verbose: false do
      "//= require golden/setting/settings\n"
    end
  end

  def inject_stylesheet_scss
    file = 'app/assets/stylesheets/application.css.scss'
    return unless File.exists? file
    log :stylesheets, 'application.css.scss'
    sentinel = "//= require_self\n"
    insert_into_file file, before: sentinel, verbose: false do
      "//= require golden/setting/settings\n"
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

  def inject_layout
    file = 'app/views/layouts/application.html.erb'
    sentinel = "<%= yield %>\n"
    gsub_file file, "<%= yield %>\n" do |match|
      %Q{<div class="<%= controller_name %>"><%= yield %></div>\n}
    end
  end
end
