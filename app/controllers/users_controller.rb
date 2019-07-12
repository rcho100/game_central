require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

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
        if @user = User.find_by(username: params[:username])
          flash[:message] = "That username is taken, unfortunately. Please enter a different username."
          redirect to "/signup"
        else
          @user = User.create(params)
          redirect to "/login"
        end
      end
    end
  end

  get '/login' do
    if logged_in?
      redirect to "/games"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id 
      redirect to "/games"
    else
      redirect to "/login"
    end
  end

  get '/user/index' do
    @user = current_user
    erb :'/users/index'
  end

  get '/logout' do
    if logged_in?
      session.clear
    end
    redirect to "/login"
  end

end