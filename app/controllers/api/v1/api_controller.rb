class Api::V1::ApiController < ActionController::Base
  private
    def organization
      @organization ||= Organization.new
    end
end
