class GamesController < ApplicationController
  get '/games' do
    if logged_in?
      @games = Game.all
      erb :'/games/index'
    else
      redirect to "/login"
    end
  end

  get '/games/new' do
    if logged_in?
      erb :"/games/new"
    else
      redirect to "/login"
    end
  end

  post '/games' do
    if params[:name] == "" || params[:genre] == "" || params[:system] == "" || params[:reason] == ""
      redirect to "/games/new"
    else
      @game = Game.create(params)
      @user = current_user
      @user.games << @game
      redirect to "/games/#{@game.id}"
    end
  end

  get '/games/:id' do
    if logged_in?
      @game = Game.find_by_id(params[:id])
      erb :'/games/show'
    else
      redirect to "/login"
    end
  end
end