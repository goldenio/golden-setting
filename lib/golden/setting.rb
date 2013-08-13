require 'golden/setting/version'

module Golden
  module Setting
    mattr_accessor :setting_class
    @@setting_class = 'Setting'

    mattr_accessor :table_name
    @@table_name = 'golden_settings'

    mattr_accessor :field_types
    @@field_types = [
      ['string', :string],
      ['boolean', :boolean],
      ['select', :select],
      ['radio_buttons', :radio_buttons],
      ['check_boxes', :check_boxes]
    ]

    mattr_accessor :groups
    @@groups = []

    mattr_accessor :default_group
    @@default_group = ''

    mattr_accessor :group_delimiter
    @@group_delimiter = '.'

    mattr_accessor :skip_groups_method
    @@skip_groups_method = nil

    mattr_accessor :skip_settings
    @@skip_settings = []

    mattr_accessor :default_tab
    @@default_tab = ''

    mattr_accessor :permitted_fields
    @@permitted_fields = [
      :field_type, :field_values, :group, :name, :value
    ]

    def self.configure
      yield self
    end
  end
end

require 'golden/setting/error'
require 'golden/setting/group'
require 'golden/setting/name'
require 'golden/setting/value'
require 'golden/setting/form_option'
require 'golden/setting/action'
require 'golden/setting/base'
require 'golden/setting/cache'
require 'golden/setting/resource'

require 'golden/setting/engine'
