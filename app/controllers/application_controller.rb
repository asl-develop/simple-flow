class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :login_required

  private
  def authorize
    if session[:user_id]
      @current_user = User.find_by_id(session[:user_id])
    end
    session.delete(:user_id) if @current_user.nil?
  end

  def login_required
    unless logged_in?
      redirect_to controller: :sessions, action: :new
    end
  end

  def logged_in?
    !!@current_user
  end

end
