class SessionsController < ApplicationController

  skip_before_filter :login_required

  def new
  end

  def create
    session.delete(:user_id)
    puts params
    user = User.authenticate(params[:login_id],params[:password])

    if user
      session[:user_id] = user.id
      redirect_to params[:from] || :root
    else
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to :root
  end


end
