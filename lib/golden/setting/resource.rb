module Golden
  module Setting
    class Resource < Base
      belongs_to :resource

      class << self
        def bind resource
          @resource = resource
          self
        end

        def unbind
          @resource = nil
          self
        end

        def with_resource resource = @resource
          where(resource_type: resource.class.name).
          where(resource_id: resource.id)
        end

        def named name, resource = @resource
          with_resource(resource).where(name: name)
        end

        def object name, resource = @resource
          named(name, resource).first
        end

        def new_object name, resource = @resource
          named(name, resource).new
        end

        def first_or_new_object name, resource = @resource
          named(name, resource).first_or_initialize
        end

        def select_object fields = %w{name value}, resource = @resource
          with_resource(resource).select(fields)
        end
      end
    end
  end
end
