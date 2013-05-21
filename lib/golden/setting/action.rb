module Golden
  module Setting
    module Action
      extend ActiveSupport::Concern
      included do
      end

      module ClassMethods
        # Setting.add 'theme', 'name', 'golden', :select, %w(golden white)
        def add group, name, value, field_type = nil, field_values = nil
          object(name) ||
          new_object(name).tap do |s|
            s.group = group
            s.value = value
            s.field_type = field_type if field_type
            s.field_values = field_values if field_values
            s.save!
          end
        end

        def destroy name
          raise Error::SettingNotFound, name unless self[name]
          object(name).destroy
        end

        def select_object
          raise Error::SettingNoMethod, :select_object unless defined? super
          super
        end

        def list starting_with = nil
          result = {}
          records = select_object
          if starting_with
            records = records.where('name LIKE ?', "#{starting_with}%")
          end
          records.each do |record|
            result[record.name] = record.value
          end
          result.with_indifferent_access
        end

        def merge! name, value
          raise Error::SettingNotFound, name unless self[name]
          raise Error::SettingNotHash, value unless value.is_a? Hash

          old_value = self[name] || {}
          raise Error::SettingNotHash, old_value unless old_value.is_a? Hash

          new_value = old_value.merge(value)
          self[name] = new_value if new_value != old_value

          new_value
        end
      end
    end
  end
end
