class Clothing < ActiveRecord::Base
  has_many :closets
  has_many :users, through: :closets
  has_many :clothing_weathers
  has_many :weathers, through: :clothing_weathers

  def self.clothingNames
    hash = Hash.new
    Clothing.all.each {|clothing| hash[clothing.clothing_name] = clothing.id}
    hash
  end
end
