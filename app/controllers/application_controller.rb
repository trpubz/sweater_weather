class ApplicationController < ActionController::API
  rescue_from Faraday::BadRequestError, with: :bad_third_party_request_error
  rescue_from Faraday::UnauthorizedError, with: :unauthorized_error
  rescue_from Mongoid::Errors::Validations, with: :unprocessable_entity_error
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_error

  def bad_third_party_request_error(error)
    render json: {error: error.message}.to_json, status: :bad_request
  end

  def unprocessable_entity_error(error)
    # index 4 is the line number of the error summary
    render json: {error: error.message.split("\n")[4]}, status: :unprocessable_entity
  end

  def not_found_error(error)
    render json: {error: error.message.split("\n")[2]}, status: :not_found
  end

  def unauthorized_error(error)
    render json: {error: error.message.split(":").first}.to_json, status: :unauthorized
  end
end
