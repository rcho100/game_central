class GamesController < ApplicationController
  get '/games' do
    if logged_in?
      @games = Game.all
      erb :'/games/index'
    else
      redirect to "/login"
    end
  end
end