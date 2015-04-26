class AddDetailsToWords < ActiveRecord::Migration
  def change
    add_column :words, :remaining_dates, :datetime, default: Time.now
    add_column :words, :stage, :integer, default: 0
  end
end