class <%= class_name %> < Golden::Setting::Base
  include Golden::Setting::Cache
  <% if ::Rails.version.to_i < 4 %>
  attr_accessible :name, :field_type, :field_values, :group
  <% end %>
end
