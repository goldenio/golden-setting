Golden::Setting.configure do |config|
  # Define setting class.
  #config.setting_class = 'Setting'

  # Define database table.
  #config.table_name = 'golden_settings'

  # Add extra field types with array of name and value.
  # Name will be used as translation key.
  # Value is a symbol name of field types used by `simple_form`.
  #config.field_types += [
  #  ['string', :string]
  #]

  # Add avaiable groups with array of name and value.
  # Name will be used as translation key.
  # Default is a blank array. You SHOULD give one at least
  config.groups += [
    ['site', 'site']
  ]

  # Define default group with name of groups.
  # Default is ''.
  config.default_group = 'site'

  # Don't show groups by given method.
  #config.skip_groups_method = nil

  # Don't show listed settings.
  #config.skip_settings += %W{
  #}

  # Define default tab with name of groups.
  # Default is ''.
  config.default_tab = 'site'

  # Add more allowed fields for strong paramters.
  #config.permitted_fields += []

  # Define before_actions.
  config.before_actions += [
    'authenticate_user!'
  ]
end
