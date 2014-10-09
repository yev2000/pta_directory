class Teacher < ActiveRecord::Base
  has_many    :schoolclass_teachers
  has_many    :schoolclasses, through: :schoolclass_teachers
  has_many    :students, -> { uniq }, through: :schoolclasses
  has_many    :contacts, as: :contactable

  validates :lastname, presence: true

  def first_last
    (firstname && (firstname.size > 0) ? firstname + " " : "") + lastname
  end

  def last_first
    lastname + (firstname && (firstname.size > 0) ? ", " + firstname : "")
  end

end
