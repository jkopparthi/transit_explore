class StopsController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @stops = Stop.includes(:street, :routes).order(:name)
    if @query.present?
      @stops = @stops.where("stops.name LIKE ?", "%#{Stop.sanitize_sql_like(@query)}%")
    end
        @stops = @stops.page(params[:page]).per(25)
  end

  def show
    @stop = Stop.includes(:street, :cross_street, :routes).find(params[:id])
  end
end