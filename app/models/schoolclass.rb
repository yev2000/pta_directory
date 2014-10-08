class Schoolclass < ActiveRecord::Base
  has_many    :schoolclass_students
  has_many    :schoolclass_teachers
  has_many    :teachers, through: :schoolclass_teachers
  has_many    :students, through: :schoolclass_students

end
