class Folder < ActiveRecord::Base
  belongs_to :users
  belongs_to :folders
  has_many :folders
  has_many :vocabularies
  has_many :words, :through => :vocabularies


  attr_accessor :remaining_number
end
