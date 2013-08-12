module Golden
  module Setting
    module Group
      extend ActiveSupport::Concern
      included do
        # validates :group, presence: true
      end

      module ClassMethods
        def grouped name
          where(group: name)
        end
      end
    end
  end
end
