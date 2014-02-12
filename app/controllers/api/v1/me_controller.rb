class Api::V1::MeController < Api::V1::ApiController
  def show
    @user = current_user
  end
end
