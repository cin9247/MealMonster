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
        object.first.class
      else
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
end
