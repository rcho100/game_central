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
        flash[:fill_in] = "Please fill all fields."
        redirect to "/signup"
      else
        if !!params[:email].match(/\A[\w.+-]+@\w+\.\w+\z/)
          name = params[:username].downcase
          if @user = User.find_by(username: name)
            flash[:taken] = "That username is taken, unfortunately. Please enter a different username."
            redirect to "/signup"
          else
            @user = User.create(username: name, email: params[:email], password: params[:password])
            redirect to "/login"
          end
        else
          flash[:valid_email] = "Please enter a valid email address."
          redirect to "/signup"
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
    name = params[:username].downcase
    @user = User.find_by(username: name)
    if @user 
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id 
        redirect to "/user/index"
      else
        flash[:incorrect] = "Incorrect password. Please try again."
        redirect to "/login"
      end
    else
      flash[:no_username] = "The given username does not match our records. Please try again or sign up if you don't have an account yet."
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