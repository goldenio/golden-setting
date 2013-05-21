module Golden
  module Setting
    module Error
      class SettingNotFound < RuntimeError
        def initialize name, msg = nil
          @name = name
          super msg
        end

        def to_s
          "Setting name '#{@name}' not found!"
        end
      end

      class SettingNoMethod < NoMethodError
        def initialize method, msg = nil
          @method = method
          super msg
        end

        def to_s
          raise "Please define method '#{@method}' first!"
        end
      end

      class SettingNotHash < TypeError
        def initialize value, msg = nil
          @value = value
          super msg
        end

        def to_s
          "Setting value '#{@value}' is not a hash!"
        end
      end
    end
  end
end
