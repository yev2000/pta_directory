class AddUserToFamily < ActiveRecord::Migration
  def change
    add_column "families", "user_id", :integer
  end
end
