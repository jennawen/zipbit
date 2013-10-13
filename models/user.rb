class User < ActiveRecord::Base
  has_many :posts
  validates :user_name, :password, presence: true
  validates :user_name, uniqueness: true
end