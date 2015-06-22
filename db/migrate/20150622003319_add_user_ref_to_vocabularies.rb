class AddUserRefToVocabularies < ActiveRecord::Migration
  def change
    add_reference :vocabularies, :user, index: true
    add_foreign_key :vocabularies, :users
  end
end
