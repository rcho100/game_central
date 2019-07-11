class UsersController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect to "/games"
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    if logged_in?
      redirect to "/games"
    else
      if params[:username] == "" || params[:email] == "" || params[:password] == ""
        redirect to "/signup"
      else
        @user = User.create(params)
        redirect to "/login"
      end
    end
  end

end