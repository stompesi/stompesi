class ChangeDataTypeForVocabularies < ActiveRecord::Migration
  def change
    
    remove_reference :vocabularies, :user
    remove_foreign_key :vocabularies, :users

    add_reference :vocabularies, :folder, index: true
    add_foreign_key :vocabularies, :folders
  end
end
