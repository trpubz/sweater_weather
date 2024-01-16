class ApplicationController < ActionController::API
  rescue_from Faraday::BadRequestError, with: :bad_third_party_request_error
  rescue_from Mongoid::Errors::Validations, with: :unprocessable_entity_error
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_error
  rescue_from Faraday::UnauthorizedError, with: :unauthorized_error

  def bad_third_party_request_error(error)
    render json: {error: error.message}, status: :bad_request
  end

  def unprocessable_entity_error(error)
    render json: {error: error.message}, status: :unprocessable_entity
  end

  def not_found_error(error)
    render json: {error: error.message}, status: :not_found
  end

  def unauthorized_error(error)
    render json: {error: error.message}, status: :unauthorized
  end
end
