class CreateSchoolclassTeachers < ActiveRecord::Migration
  def change
    create_table :schoolclass_teachers do |t|
      t.integer :teacher_id
      t.integer :schoolclass_id

      t.timestamps
    end
  end
end
