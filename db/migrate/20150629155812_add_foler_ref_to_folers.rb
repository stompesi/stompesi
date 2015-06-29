class AddFolerRefToFolers < ActiveRecord::Migration
  def change
    add_reference :folders, :folder, index: true
    add_foreign_key :folders, :folders
  end
end
