class CreateSchoolclass < ActiveRecord::Migration
  def change
    create_table :schoolclasses do |t|
      t.string  :name

      t.timestamps
    end
  end
end
