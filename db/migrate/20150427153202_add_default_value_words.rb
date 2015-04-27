class AddDefaultValueWords < ActiveRecord::Migration
  def change
    change_column_default :words, :remaining_dates, nil
  end
end
