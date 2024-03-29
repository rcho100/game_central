class GamesController < ApplicationController
  get '/games' do
    redirect_if_not_logged_in
    
    @games = Game.all
    erb :'/games/index'
  end

  get '/games/new' do
    redirect_if_not_logged_in

    erb :"/games/new"
  end

  post '/games' do
    if params[:name] == "" || params[:genre] == "" || params[:system] == "" || params[:reason] == ""
      flash[:fill_in] = "Please fill all fields."
      redirect to "/games/new"
    else
      @game = Game.create(params)
      @user = current_user
      @game.user_id = @user.id
      @game.save
      redirect to "/games/#{@game.id}"
    end
  end

  get '/games/:id' do
    redirect_if_not_logged_in
    
    @game = Game.find_by_id(params[:id])
    erb :'/games/show'
  end

  get '/games/:id/edit' do
    redirect_if_not_logged_in
    
    @game = Game.find_by_id(params[:id])
    creator_id = @game.user_id
    if current_user.id != creator_id
      flash[:wrong_user] = "You can only delete or edit game posts that have you created."
      redirect to "/games/#{@game.id}"
    end
    erb :'/games/edit'
  end

  patch '/games/:id' do
    @game = Game.find_by_id(params[:id])
    if @game.user == current_user
      if params[:name] == "" || params[:genre] == "" || params[:system] == "" || params[:reason] == ""
        flash[:fill_in] = "Please fill all fields."
        redirect to "/games/#{@game.id}/edit"
      else
        @game.update(name: params[:name], genre: params[:genre], system: params[:system], reason: params[:reason])
      end
    else
      flash[:wrong_user] = "You can only delete or edit game posts that have you created."
    end
    redirect to "/games/#{@game.id}"
  end

  delete '/games/:id' do
    redirect_if_not_logged_in

    @game = Game.find_by_id(params[:id])
    if @game.user == current_user
      @game.delete
    else
      flash[:wrong_user] = "You can only delete or edit game posts that have you created."
      redirect to "/games/#{@game.id}"
    end
    redirect to "/games"
  end
end