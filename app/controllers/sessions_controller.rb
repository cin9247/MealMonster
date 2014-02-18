class SessionsController < ApplicationController
  skip_before_filter :login_required, only: [:new, :create]

  def new
  end

  def create
    ## TODO login interactor
    user = UserMapper.new.find_by_name params["session"]["username"]

    if login! params["session"]["username"], params["session"]["password"]
      redirect_to root_path, notice: "Sie haben sich erfolgreich eingeloggt"
    else
      flash.now[:error] = "Falcher Benutzername oder falsches Passwort."
      render :new
    end
  end

  def destroy
    self.current_user = nil
    redirect_to login_path, notice: "Sie sind erfolgreich ausgeloggt."
  end
end
