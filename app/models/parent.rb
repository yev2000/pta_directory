class Parent < ActiveRecord::Base
  has_one     :address, as: :addressable
  has_many    :contacts, as: :contactable
  belongs_to  :family
  has_many    :students, through: :family

  validates :firstname, presence: true
  validates :lastname, presence: true
  
end




