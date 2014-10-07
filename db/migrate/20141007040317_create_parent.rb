class CreateParent < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.string  :firstname
      t.string  :lastname
      t.integer :family_id

      t.timestamps
    end
  end
end
