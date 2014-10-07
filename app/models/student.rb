class Student < ActiveRecord::Base
  has_many    :contacts, as: :contactable
  belongs_to  :family
  has_many    :parents, through: :family

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :family, presence: true
  
end

