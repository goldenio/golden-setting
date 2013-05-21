module Golden
  module Setting
    module FormOption
      extend ActiveSupport::Concern
      included do
        cattr_accessor :default_form_options
        @@default_form_options = {
          type: :string,
          collection: []
        }
        serialize :form_options
        attr_accessible :field_type, :field_values
      end

      module ClassMethods
        def is_true? name
          record = object(name)
          raise Error::SettingNotFound, name unless record

          case record.field_type
          when :boolean
            self[name] == '1'
          else
            self[name].present?
          end
        end
      end

      def initialize attributes = nil, options = {}
        super attributes, options
        self.form_options
      end

      def form_options
        case self[:form_options]
        when String
          YAML::load self[:form_options]
        when Hash
          super
        else
          self[:form_options] = default_form_options.dup
        end
      end

      def field_type
        form_options[:type]
      end

      def field_type= new_value
        return unless new_value
        self.form_options[:type] = new_value.to_sym
      end

      def field_values
        case form_options[:collection]
        when String
          eval form_options[:collection]
        else
          form_options[:collection]
        end
      end

      def field_values= new_value
        return unless new_value
        self.form_options[:collection] = eval(new_value)
      end
    end
  end
end
