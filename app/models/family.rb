class Family < ActiveRecord::Base

  include Searchable

  has_many    :parents
  has_many    :students
  has_one     :address, as: :addressable
  belongs_to  :family_administrator, foreign_key: 'user_id', class_name: 'User'

  validates   :name, presence: true

  def get_administrator
    # what user ID is allowed to administer (edit) this object
    self.family_administrator
  end

#  def Family.search_for(search_term, do_recurse = false)
#    normalized_search_term = normalize_search_term_for_SQL_search(search_term)
#    retval = Family.where("name LIKE ?", normalized_search_term)
#
#    retval += Parent.search_for(search_term, do_recurse) if do_recurse
#
#    retval += Parent.search_for(search_term, do_recurse) if do_recurse
#
#    binding.pry
#
#    retval
#  end

end

