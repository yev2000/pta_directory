class CreateContact < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string  :contact_type     # like email or phone
      t.string  :contact_data     # the email address or phone #
      t.string  :contactable_type # a teacher or parent is contactable
      t.integer :contactable_id   # the key for the teacher or parent
      t.timestamps
    end
  end
end
