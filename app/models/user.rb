class User < ActiveRecord::Base
  has_many :closets
  has_many :clothings, through: :closets
end
