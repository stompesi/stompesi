class Vocabulary < ActiveRecord::Base
  has_many :words
  belongs_to :folders

  attr_accessor :remaining_number
end
