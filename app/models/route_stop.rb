class RouteStop < ApplicationRecord
  belongs_to :route
  belongs_to :stop

  validates :route_id, uniqueness: { scope: :stop_id }
  validates :route_id, :stop_id, presence: true
end