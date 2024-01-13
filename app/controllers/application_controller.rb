class ApplicationController < ActionController::API
  rescue_from Faraday::BadRequestError, with: :bad_third_party_request_error

  def bad_third_party_request_error(error)
    render json: {error: error.message}, status: :bad_request
  end
end
