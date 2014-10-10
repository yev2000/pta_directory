class Parent < ActiveRecord::Base
  include Searchable

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

  def get_administrator
    # what user ID is allowed to administer (edit) this object
    return self.family.get_administrator unless self.family.nil?
    return nil
  end
  
end
