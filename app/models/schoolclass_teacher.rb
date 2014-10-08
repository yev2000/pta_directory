class SchoolclassTeacher < ActiveRecord::Base
  belongs_to :schoolclass
  belongs_to :teacher
end
