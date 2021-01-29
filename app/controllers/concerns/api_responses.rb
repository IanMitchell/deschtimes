module ApiResponses
  extend ActiveSupport::Concern

  def api_response(status, message)
    render json: { message: message },
           status: status
  end

  def success_response(message)
    api_response(200, message)
  end

  def error_response(status, message)
    api_response(status, message)
  end
end
