require 'active_record'

class ::Setting < Golden::Setting::Base
end

class ::CachedSetting < Golden::Setting::Base
  include Golden::Setting::Cache
end

class User < ::ActiveRecord::Base
end

class Manager < User
  include Golden::Setting::Resourced
end
