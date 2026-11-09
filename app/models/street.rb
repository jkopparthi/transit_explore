class Street < ApplicationRecord
  has_many :stops
  has_many :cross_street_stops, class_name: "Stop", foreign_key: :cross_street_id

  validates :transit_id, presence: true, uniqueness: true
  validates :name, presence: true
end