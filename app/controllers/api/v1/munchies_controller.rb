class Api::V1::MunchiesController < ApplicationController
  def search
    results = MunchiesFacade.get_business(location: params[:destination], cuisine: params[:food].downcase)

    render json: {
      data: {
        id: nil,
        type: "munchie",
        attributes: results
      }
    }
  end
end
