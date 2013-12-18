class Api::V1::ApiController < ActionController::Base
  before_filter :authenticate

  rescue_from BaseMapper::RecordNotFound do
    render :json => {error: "not found"}, status: 404
  end

  private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        authenticated? username, password
      end
    end

    def authenticated?(name, password)
      user = UserMapper.new.find_by_name name

      user && BCrypt::Password.new(user.password_digest) == password
    end
end
