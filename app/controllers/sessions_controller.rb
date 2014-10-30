class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def index
    if current_user
      @sessions = current_user.sessions 
    else
      redirect_to root_path
    end
  end
  
  def new
    render :new
  end
  
  def create
    user = User.find_by_credentials(
      params[:session][:user_name],
      params[:session][:password]
    )
    
    if user
      login_user!(user)
      redirect_to root_path
    else
      self.flash.now[:errors] = ["Invalid username/password combination"]
      render :new
    end
  end
  
  
  def destroy
    session_to_destroy = Session.find(params[:id])
    if current_user.id != session_to_destroy.user_id
      redirect_to root_path
      return
    end
    
    if session_to_destroy.session_token == session[:session_token]
      session[:session_token] = nil
    end
    
    session_to_destroy.destroy!
    redirect_to root_path
  end
end
