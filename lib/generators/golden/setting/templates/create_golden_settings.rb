class CreateGoldenSettings < ActiveRecord::Migration
  def change
    create_table :golden_settings do |t|
      t.string     :group
      t.string     :name, null: false
      t.text       :value
      t.string     :form_options
      t.references :resource, polymorphic: true
      t.timestamps
    end

    add_index :golden_settings,
      [:group, :name, :resource_id, :resource_type],
      unique: true,
      name: 'index_golden_settings_on_group_and_name_and_resource'
  end
end
