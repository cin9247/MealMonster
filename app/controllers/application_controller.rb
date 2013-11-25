class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def kitchen
      @kitchen ||= organization.kitchen
    end
    helper_method :kitchen

    def organization
      @organization ||= Organization.new
    end
    helper_method :organization

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
        parse_from_to params
      else
        this_week
      end
    end

    def parse_dates_or_default_to_next_week
      if params[:from] && params[:to]
        parse_from_to params
      else
        next_week
      end
    end

    def parse_from_to(params)
      [Date.parse(params[:from]), Date.parse(params[:to])]
    end

    def next_week
      [Date.today.next_week(:monday), Date.today.next_week(:sunday)]
    end

    def this_week
      [Date.today.beginning_of_week, Date.today.end_of_week]
    end

    def logged_in?
      !current_user.nil?
    end
    helper_method :logged_in?

    def current_user
      return unless session[:user_id]
      @current_user ||= UserMapper.new.find session[:user_id]
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
end
