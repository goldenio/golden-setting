# Golden Setting

The `golden-setting` persists settings in database and keeps alive in cache.

A web interface is provied to let users can update easily.

## Requirement

For Rails 4 project, `Gemfile` should have

```ruby
gem 'devise', '> 3.0'
gem 'cancan'
gem 'simple_form', '~> 3.0.0.rc'
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails'
gem 'will_paginate'
gem 'rails-theme-helper'
```

If you add `gem 'protected_attributes'` in your `Gemfile`, remember to add

```ruby
attr_accessible :name, :field_type, :field_values, :group
```

to your `Setting` class.

For Rails 3 project, `Gemfile` should have

```ruby
gem 'devise', '>= 2.0', '< 3.0'
gem 'cancan'
gem 'simple_form', '>= 2.0', '< 3.0'
gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails'
gem 'will_paginate'
gem 'rails-theme-helper'
```

Please make sure these gems are installed and configured properly.

## Installation

Add `golden-setting` to your application's Gemfile.

```ruby
gem 'golden-setting'
```

Then bundle gems, generate settings and migrate database.

```ruby
$ bundle
$ rails generate golden:setting:install setting
$ rake db:migrate
```

Remember add setting abilities for `cancan`.

```ruby
can :index, Setting
can :batch_update, Setting
```

## Configuration

You will need to add these basic configures of `golden-setting` for your needs.

* `groups` for grouping settings with a name
* `default_group` for saving settings with a group
* `default_tab` for a group of settings shown in tab views

Edit `config/initializers/golden_setting.rb` for more detail.

## Usage

### Create/Read/Update/Destroy settings

You can add setting with named group.

```ruby
Setting.add 'google', 'google_analytics_token', 12345
Setting.add 'api', 'golden_api_credentials', { username: 'tsechingho', password: 'secret' }
Setting.add 'theme', 'theme_color', 'golden', :select, "%w(golden white)"
```

or add setting with blank group.

```ruby
Setting.google_analytics_token = 12345
Setting.golden_api_credentials = { username: 'tsechingho', password: 'secret' }
Setting.theme_color = 'golden'
```

Read settings (group regardless).

```ruby
Setting.google_analytics_token
Setting.golden_api_credentials
Setting.theme_color
```

Update settings (group regardless).

```ruby
Setting.google_analytics_token = 'abced'
Setting.merge!(:golden_api_credentials, password: 'topsecret')
Setting.theme_color = 'white'
```

Destroy settings.

```ruby
Setting.destroy :google_analytics_token
Setting.destroy :golden_api_credentials
Setting.destroy :theme_color
```

### List settings

You can add setting with complex name with `[]=` method, and retrieve with `[]` method.

And list settings as key-value pair with/without name prefix.

```ruby
Setting['preferences.color'] = :blue
Setting['preferences.size'] = :large
Setting['license.key'] = 'ABC-DEF'
Setting['license.key']
Setting.list
Setting.list('preferences.')
```

### Default settings

You can add virtaul settings for your application by setting defaults.

Add `config/initializers/golden_setting_defaults.rb`.

```ruby
YourApp::Application.config.after_initialize do
  Setting.defaults[:administrator] = 'tsechingho'
end
```

These virtaul settings were not saved in database.

```ruby
Setting.named('administrator').count    # => 0
Setting.administrator    # => 'tsechingho'
```

You can also save default settings in database after initializing your application.

```ruby
YourApp::Application.config.after_initialize do
  Setting.save_default :manager, 'tsechingho'
end
```

These default settings were saved in database with default group.

```ruby
Setting.named('manager').count    # => 1
Setting.object('manager').group    # => 'site'
Setting.manager    # => 'tsechingho'
```

### Resourced settings

Settings may be bound to any existing ActiveRecord object.

```ruby
class User < ActiveRecord::Base
  include Golden::Setting::Resourced
end
```

Then you can set or get settings.

```ruby
user = User.first
user.settings.theme_color = 'golden'
user.settings.theme_color    # => 'golden'
user.settings.list    # => { "theme_color" => 'golden' }
```

You can find users having or not having some settings by (experimental) scopes.

```ruby
User.with_settings.to_a.size    # => 1
User.with_settings_for('theme_color').count    # => 1
User.without_settings.count
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT
