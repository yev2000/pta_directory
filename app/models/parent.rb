class Parent < ActiveRecord::Base
  has_one     :address, as: :addressable
  has_many    :contacts, as: :contactable
  belongs_to  :family
  has_many    :students, through: :family

  validates :firstname, presence: true, length: {minimum: 1}
  validates :lastname, presence: true, length: {minimum: 1}
  
  def name_string
    firstname + " " + lastname
  end
  
end
