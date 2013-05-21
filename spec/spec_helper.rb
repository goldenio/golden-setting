$LOAD_PATH.unshift File.dirname(__FILE__)

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/concern'
require 'action_dispatch'
module Rails
  class << self
    def env
      @_env ||= 'test'
    end

    def cache
      @cache ||= ActiveSupport::Cache::MemoryStore.new
    end
  end
end
require 'rails/engine'
require 'rails/railtie'
require 'active_record'

require 'golden/setting'
Golden::Setting::Engine.config.autoload_paths.each do |path|
  $LOAD_PATH.unshift path
end
require 'golden/setting/resourced'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
end
