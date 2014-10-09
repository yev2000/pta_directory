class Family < ActiveRecord::Base

  has_many    :parents
  has_many    :students
  has_one     :address, as: :addressable
  belongs_to  :family_administrator, foreign_key: 'user_id', class_name: 'User'

  validates   :name, presence: true

  def get_administrator
    # what user ID is allowed to administer (edit) this object
    self.family_administrator
  end

end

