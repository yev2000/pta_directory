class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string      :address_line1
      t.string      :address_line2
      t.string      :city
      t.string      :state
      t.integer     :zipcode
      t.string      :addressable_type # like parent or family
      t.integer     :addressable_id   #  parent or family ID
      t.timestamps
    end
  end
end
