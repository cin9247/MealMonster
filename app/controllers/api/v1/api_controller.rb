class Api::V1::ApiController < ActionController::Base
  before_filter :authenticate

  rescue_from BaseMapper::RecordNotFound do
    render :json => {error: "not found"}, status: 404
  end

  rescue_from Policy::NotAuthorized do
    render :json => {error: "unauthorized"}, status: 401
  end

  rescue_from ArgumentError do |exception|
    if exception.message == "invalid date"
      render :json => {error: "invalid date"}, status: 400
    else
      raise exception
    end
  end

  private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        if user = authenticated?(username, password)
          @current_user = user
        else
          raise Policy::NotAuthorized
        end
      end
    end

    def authenticated?(name, password)
      user = UserMapper.new.find_by_name name

      if user && BCrypt::Password.new(user.password_digest) == password
        user
      else
        nil
      end
    end

    def current_user
      @current_user || Guest.new
    end

    def interact_with(use_case, request)
      InteractorFactory.execute(use_case, request, current_user)
    end
end
