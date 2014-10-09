class User < ActiveRecord::Base
  include Sluggable

  has_many    :families   # can administer potentially many families

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true, length: {minimum: 3}
  validates :password, presence: true, on: :create, length: {minimum: 4}

  def roles_hash
    {
      admin: "Admin", 
      rootadmin: "RootAdmin", 
      schooladmin: "SchoolAdmin",
      user: "User"
    }
  end

  def get_field_for_slugging
    self.username
  end

  def avail_roles
    roles_hash.values
  end

  def superadmin?
    self.role == roles_hash[:rootadmin]
  end

  def admin?
    self.role == roles_hash[:admin] || superadmin?
  end

  def schooladmin?
    self.role == roles_hash[:schooladmin] || superadmin?
  end
end

