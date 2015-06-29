class FixColumName < ActiveRecord::Migration
  def change
    rename_column :vocabularies, :title, :name
  end
end
