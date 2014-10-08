class Parent < ActiveRecord::Base
  has_one     :address, as: :addressable
  has_many    :contacts, as: :contactable
  belongs_to  :family
  has_many    :students, through: :family

  validates :firstname, presence: true, length: {minimum: 1}
  validates :lastname, presence: true, length: {minimum: 1}
  
  def first_last
    firstname + " " + lastname
  end

  def last_first
    lastname + ", " + firstname
  end

end
