class RoutesController < ApplicationController
  def index
    @routes = Route.includes(:route_stops)
                   .order(Arel.sql("CAST(route_number AS INTEGER), route_number"))
                   .page(params[:page]).per(25)
  end

  def show
    @route = Route.find(params[:id])
    @stops = @route.stops.includes(:street).order(:name).page(params[:page]).per(25)
  end
end