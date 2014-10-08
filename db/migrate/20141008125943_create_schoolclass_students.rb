class CreateSchoolclassStudents < ActiveRecord::Migration
  def change
    create_table :schoolclass_students do |t|
      t.integer :student_id
      t.integer :schoolclass_id

      t.timestamps
    end
  end
end
