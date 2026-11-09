class Route < ApplicationRecord
  has_many :route_stops, dependent: :destroy
  has_many :stops, through: :route_stops

  validates :route_number, presence: true, uniqueness: true
  validates :name, presence: true
end