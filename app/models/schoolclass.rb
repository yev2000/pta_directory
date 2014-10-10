class Schoolclass < ActiveRecord::Base
  include Searchable

  has_many    :schoolclass_students
  has_many    :schoolclass_teachers
  has_many    :teachers, through: :schoolclass_teachers
  has_many    :students, through: :schoolclass_students

  def get_administrator
    # what user ID is allowed to administer (edit) this object
    return nil ## only admins are allowed to administer
  end

end
