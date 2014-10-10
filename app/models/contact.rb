class Contact < ActiveRecord::Base
  include Searchable

  belongs_to :contactable, polymorphic: true

end
