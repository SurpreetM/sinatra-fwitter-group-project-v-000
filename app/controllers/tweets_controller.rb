class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'tweets/index'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
    erb :'/tweets/new'
    else
      redirect to "/login"
    end
  end

  post '/tweets' do
    if logged_in?
      if params[:content] == ""
        redirect to '/tweets/new'
      else
        @tweet = current_user.tweets.new(:content => params[:content])
        if @tweet.save
          redirect to "/tweets/#{@tweet.id}"
        else
          redirect to "/tweets/new"
        end
      end
    end
  end

  get '/tweets/:id' do
    if logged_in?
    @tweet = Tweet.find_by(params[:id])
    erb :'tweets/show'
    else
    redirect to "/login"
    end
  end

  delete '/tweets/:id/delete' do #destroy action
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.delete
    redirect to '/tweets'
  end

  get '/tweets/:id/edit' do
    if logged_in?
    @tweet = Tweet.find_by_id(params[:id])
      if @tweet && @tweet.user_id == current_user.id
        erb :'tweets/edit'
        else
          redirect to '/tweets'
        end
      else
        redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    if logged_in?
      if params[:content] == ""
        redirect to "/tweets/#{params[:id]}/edit"
      else
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user == current_user
          if @tweet.update(content: params[:content])
            redirect to "/tweets/#{@tweet.id}"
          else
            redirect to "/tweets/#{@tweet.id}/edit"
          end
        else
          redirect to '/tweets'
        end
      end
    else
      redirect to '/login'
    end
  end

end
