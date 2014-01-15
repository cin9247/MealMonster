class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    request = OpenStruct.new(name: params[:user][:name], password: params[:user][:password])
    user = Interactor::RegisterUser.new(request).run.object
    self.current_user = user
    redirect_to root_path, notice: "Sie haben sicher erfolgreich registriert."
  end
end
