class Address < ActiveRecord::Base
  include Searchable
  
  belongs_to :addressable, polymorphic: true

end
