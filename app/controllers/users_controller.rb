class UsersController < ApplicationController
  def new
    @roles = ["admin", "driver", "user"]
    @user = User.new
  end

  def edit
    @roles = ["admin", "driver", "user"]
    @user = UserMapper.new.find params[:id]
  end

  def update
    user = UserMapper.new.find params[:id]
    user.name = params[:user][:name]
    UserMapper.new.update user
    interact_with :set_role, OpenStruct.new(user_id: user.id, role: params[:user][:role])

    redirect_to users_path
  end

  def index
    @users = UserMapper.new.fetch
  end

  def create
    request = OpenStruct.new(name: params[:user][:name], password: params[:user][:password])
    user = interact_with(:register_user, request).object
    request = OpenStruct.new(user_id: user.id, role: params[:user][:role])
    interact_with :set_role, request
    self.current_user = user
    redirect_to root_path, notice: "Sie haben sicher erfolgreich registriert."
  end
end
