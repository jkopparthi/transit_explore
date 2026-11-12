class StreetsController < ApplicationController
  def index
        @streets = Street.includes(:stops).order(:name).page(params[:page]).per(25)
  end

  def show
    @street = Street.find(params[:id])
    @stops = @street.stops.order(:name)
    @cross_street_stops = @street.cross_street_stops.order(:name)
  end
end