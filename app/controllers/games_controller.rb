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

  get '/games/:id/edit' do
    if logged_in?
      @game = Game.find_by_id(params[:id])
      erb :'/games/edit'
    else
      redirect to "/login"
    end
  end

  patch '/games/:id' do
    @game = Game.find_by_id(params[:id])
    if @game.user == current_user
      @game.update(name: params[:name], genre: params[:genre], system: params[:system], reason: params[:reason])
      redirect to "/games/#{@game.id}"
    else
      redirect to "/users/index"
    end
  end

  delete '/games/:id' do
    if logged_in?
      @game = Game.find_by_id(params[:id])
      if @game.user == current_user
        @game.delete
      else
        redirect to "/games/#{@game.id}"
      end
      redirect to "/games"
    else
      redirect to "/login"
    end
  end
end