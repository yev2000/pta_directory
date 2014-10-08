class SchoolclassStudent < ActiveRecord::Base
  belongs_to :schoolclass
  belongs_to :student
end


