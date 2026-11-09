class Stop < ApplicationRecord
  belongs_to :street
  belongs_to :cross_street, class_name: "Street", optional: true
  has_many :route_stops, dependent: :destroy
  has_many :routes, through: :route_stops

  validates :stop_number, presence: true, uniqueness: true
  validates :name, presence: true

  def quality_score
    return nil if departures_per_day.nil?

    route_points   = [routes.size * 10, 30].min
    freq_points    = [departures_per_day / 2, 40].min   # 80+ departures per day = full marks
    shelter_points = (has_shelter ? 15 : 0) + (has_bench ? 5 : 0)

    route_points + freq_points + shelter_points
  end

  def quality_label
    case quality_score
    when nil then "Not rated yet"
    when 70.. then "Excellent"
    when 40...70 then "Fair"
    else "Poor"
    end
  end
end