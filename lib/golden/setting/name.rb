module Golden
  module Setting
    module Name
      extend ActiveSupport::Concern
      included do
        attr_accessible :name
        validates :name, presence: true
      end

      module ClassMethods
        def named name
          raise Error::SettingNoMethod, :named unless defined? super
          super
        end

        def object name
          named(name).first
        end

        def new_object name
          named(name).new
        end

        def first_or_new_object name
          named(name).first_or_initialize
        end
      end
    end
  end
end
