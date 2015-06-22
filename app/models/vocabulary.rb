class Vocabulary < ActiveRecord::Base
  has_many :words
  belongs_to :users
end
