class UserController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect to "/games"
    else
      erb :'/user/signup'
    end
  end
end