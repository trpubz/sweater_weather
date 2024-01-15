class ApplicationController < ActionController::API
  rescue_from Faraday::BadRequestError, with: :bad_third_party_request_error
  rescue_from Mongoid::Errors::Validations, with: :unprocessable_entity_error

  def bad_third_party_request_error(error)
    render json: {error: error.message}, status: :bad_request
  end

  def unprocessable_entity_error(error)
    render json: {error: error.message}, status: :unprocessable_entity
  end
end
