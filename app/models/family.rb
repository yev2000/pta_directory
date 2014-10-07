class Family < ActiveRecord::Base

  has_many  :parents
  has_many  :students
  has_one   :address, as: :addressable

  validates :name, presence: true

end

