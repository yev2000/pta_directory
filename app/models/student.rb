class Student < ActiveRecord::Base
  has_many    :contacts, as: :contactable
  belongs_to  :family
  has_many    :parents, through: :family

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :family, presence: true

  def first_last
    firstname + (nickname && (nickname.size > 0) ? " (#{nickname}) " : " ") + lastname
  end

  def last_first
    lastname + ", " + firstname + (nickname && (nickname.size > 0) ? " (#{nickname})" : "")
  end

  def family_siblings
    # this is an array of students within the student's family
    # who are not including the student themselves
    if self.family
      Student.where("family_id = ? AND id != ?", family_id, id)
    else
      nil
    end
  end

end

