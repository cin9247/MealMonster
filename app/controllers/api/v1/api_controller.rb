class Api::V1::ApiController < ActionController::Base
  rescue_from BaseMapper::RecordNotFound do
    render :json => {error: "not found"}, status: 404
  end
end
