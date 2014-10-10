class Teacher < ActiveRecord::Base
  include Searchable

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

  def get_administrator
    # what user ID is allowed to administer (edit) this object
    return nil  ## only admins are allowed to administer
  end

end
