class CreateStudent < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string      :firstname
      t.string      :lastname
      t.string      :nickname
      t.integer     :family_id

      t.timestamps
    end
  end
end
