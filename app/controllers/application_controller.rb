require "date_range"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def wrap(object)
      klass = if Array === object
        return [] if object.empty?
        object.first.class
      else
        return nil if object.nil?
        object.class
      end

      presenter_klass = Module.const_get("#{klass}Presenter")

      if Array === object
        object.map do |o|
          presenter_klass.new(o)
        end
      else
        presenter_klass.new(object)
      end
    end

    def parse_dates_or_default_to_this_week
      if params[:from] && params[:to]
        DateRange.parse(params[:from], params[:to])
      else
        DateRange.this_week
      end
    end

    def parse_dates_or_default_to_next_week
      if params[:from] && params[:to]
        DateRange.parse(params[:from], params[:to])
      else
        DateRange.next_week
      end
    end

    def logged_in?
      !current_user.is_a? Guest
    end
    helper_method :logged_in?

    def current_user
      return Guest.new unless session[:user_id]
      @current_user ||= UserMapper.new.find session[:user_id]
    rescue BaseMapper::RecordNotFound
      session.delete(:user_id)
      Guest.new
    end
    helper_method :current_user

    def current_user=(user)
      session[:user_id] = user ? user.id : nil
      @current_user = user
    end

    def login!(name, password)
      user = UserMapper.new.find_by_name name

      if user && BCrypt::Password.new(user.password_digest) == password
        self.current_user = user
      end
    end

    def interact_with(use_case, request)
      InteractorFactory.execute(use_case, request, current_user)
    end
end
