class Listing < ActiveRecord::Base
  validates :title, :description, :price, presence: true
  validates :price, numericality: true
end