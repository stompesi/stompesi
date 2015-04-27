class Word < ActiveRecord::Base
  belongs_to :vocabulary
  attr_accessor :state
end
