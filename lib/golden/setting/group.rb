module Golden
  module Setting
    module Group
      extend ActiveSupport::Concern
      included do
        attr_accessible :group
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
