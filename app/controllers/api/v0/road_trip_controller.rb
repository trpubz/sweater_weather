class Api::V0::RoadTripController < ApplicationController
  def create
    # this will throw Mongoid::Errors::DocumentNotFound if the api_key is invalid
    RoadTripFacade.validate_api_key(road_trip_params[:api_key])

    road_trip = RoadTripFacade.create_road_trip(road_trip_params[:origin], road_trip_params[:destination])
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end
end
