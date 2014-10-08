class CreateTeacher < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string  :firstname
      t.string  :lastname

      t.timestamps
    end
  end
end
