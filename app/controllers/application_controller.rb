class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def current_session
    Session.find_by(session_token: session[:session_token])
  end
  
  def current_user
    current_session.try(:user)
  end
  
  def login_user!(user)
    new_session = Session.new(user_id: user.id)
    new_session.generate_session_token!
    session[:session_token] = new_session.session_token
    new_session.ip_address = request.remote_ip
    new_session.device = browser.user_agent
    new_session.location = request.location.city
    new_session.save!
  end
  
  def redirect_if_logged_in
    redirect_to root_path if current_user  
  end

  
  helper_method :current_user, :login_user!, 
    :redirect_if_logged_in, :current_session
end
