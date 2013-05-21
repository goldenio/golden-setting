require 'active_support/core_ext/logger'
require 'active_record'
require 'sqlite3'

# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.configurations = true
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(version: 1) do
  create_table :golden_settings do |t|
    t.string     :group
    t.string     :name, null: false
    t.text       :value
    t.string     :form_options
    t.references :resource, polymorphic: true
    t.timestamps
  end

  create_table :users do |t|
    t.string :email, null: false
  end
end
