class UsersController < ApplicationController
  def new
    @roles = User::ROLES
    @user = User.new
  end

  def edit
    @roles = User::ROLES
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

  def link
    @user = UserMapper.new.find params[:id].to_i
    @customers = CustomerMapper.new.fetch
    @link = Link.new(@user)
  end

  def save_link
    request = OpenStruct.new customer_id: params[:link][:customer_id].to_i, user_id: params[:id].to_i
    interact_with :link_user_to_customer, request
    redirect_to users_path
  end

  def remove_link
    request = OpenStruct.new user_id: params[:id]
    interact_with :remove_link_from_user, request
    redirect_to users_path
  end

  def create
    request = OpenStruct.new(name: params[:user][:name], password: params[:user][:password])
    user = interact_with(:register_user, request).object
    request = OpenStruct.new(user_id: user.id, role: params[:user][:role])
    interact_with :set_role, request
    if logged_in?
      redirect_to users_path, notice: "Benutzer #{user.name} erfolgreich angelegt."
    else
      self.current_user = user
      redirect_to root_path, notice: "Sie haben sich erfolgreich registriert."
    end
  end
end
