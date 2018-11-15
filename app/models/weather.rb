class Weather < ActiveRecord::Base
  has_many :clothing_weathers
  has_many :clothings, through: :clothing_weathers
end
