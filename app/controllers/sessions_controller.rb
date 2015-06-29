class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])

    if user.nil?
      user = User.create_with_omniauth(auth)
      session[:user_id] = user.id
      folders = current_user.folders.new
      folders.name = 'root'
      folders.save!
    end

    session[:user_id] = user.id

    redirect_to folders_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end