class UsersController < ApplicationController

    get '/users/:slug' do
      if !logged_in?
        redirect to '/login'
      else
        erb :'users/show'
      end
    end


  get '/login' do
    if logged_in?
      redirect to '/users/:slug'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/loans"
    else
      redirect to '/signup'
    end
  end



  get '/signup' do
  end

  post '/signup' do
  end



  get '/logout' do
  end

end
