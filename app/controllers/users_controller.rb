class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = Interactor::CreateUser.new(params[:user][:name], params[:user][:password]).run.object
    self.current_user = user
    redirect_to root_path, notice: "Sie haben sicher erfolgreich registriert."
  end
end
