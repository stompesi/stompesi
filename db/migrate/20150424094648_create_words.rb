class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :word
      t.string :meaning
      t.string :sentence
      t.string :sentence_meaning
      t.belongs_to :vocabulary, index: true
      t.timestamps null: false
    end
  end
end
