module Golden
  module Setting
    module Value
      extend ActiveSupport::Concern
      included do
        cattr_accessor :defaults
        @@defaults = {}.with_indifferent_access
      end

      module ClassMethods
        def object name
          raise Error::SettingNoMethod, :object unless defined? super
          super name
        end

        def new_object name
          raise Error::SettingNoMethod, :new_object unless defined? super
          super name
        end

        def first_or_new_object name
          raise Error::SettingNoMethod, :first_or_new_object unless defined? super
          super name
        end

        def [] name
          record = object(name)
          record ? record.value : defaults[name.to_sym]
        end

        def []= name, value
          record = first_or_new_object(name)
          if record.value != value
            record.value = value
            record.save!
          end
          value
        end

        def is_true? name
          raise Error::SettingNoMethod, :is_true? unless defined? super
          super
        end

        def save_default name, value
          return unless self[name].nil?
          record = first_or_new_object(name)
          if record.value != value
            record.group ||= Golden::Setting.default_group
            record.value = value
            record.save!
          end
          value
        end
      end

      def value
        return if self[:value].nil?
        YAML::load self[:value]
      end

      def value= new_value
        self[:value] = new_value.to_yaml
      end
    end
  end
end
