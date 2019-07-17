require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    redirect_if_not_logged_in_for_signup

    erb :'/users/signup'
  end

  post '/signup' do
    redirect_if_not_logged_in_for_signup

      if params[:username] == "" || params[:email] == "" || params[:password] == ""
        flash[:fill_in] = "Please fill all fields."
        redirect to "/signup"
      else
        if !!params[:email].match(/\A[\w.+-]+@\w+\.\w+\z/)
          if @user = User.find_by(username: params[:username])
            flash[:taken] = "That username is taken, unfortunately. Please enter a different username."
            redirect to "/signup"
          else
            @user = User.create(params)
            flash[:success_signup] = "Signup Successful! Please login below."
            redirect to "/login"
          end
        else
          flash[:valid_email] = "Please enter a valid email address."
          redirect to "/signup"
        end
      end
  end

  get '/login' do
    redirect_if_not_logged_in

    redirect to "/games"
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user 
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id 
        flash[:success_login] = "Login successful"
        redirect to "/user/index"
      else
        flash[:incorrect] = "Incorrect password. Please try again."
        redirect to "/login"
      end
    else
      flash[:no_username] = "The given username does not match our records. Please note that the fields are case sensitive and try again or sign up if you don't have an account yet."
      redirect to "/login"
    end
  end

  get '/user/index' do
    redirect_if_not_logged_in
    
    @user = current_user
    erb :'/users/index'
  end

  get '/logout' do
    redirect_if_not_logged_in

    session.clear
    redirect to "/login"
  end

end