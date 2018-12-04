class UsersController < ApplicationController

  get '/login' do
  end

  post '/login' do
  end


  get '/users/:slug' do
    if !logged_in?
      redirect to '/login'
    else
      erb :'users/show'
    end
  end


  get '/signup' do
  end

  post '/signup' do
  end



  get '/logout' do
  end

end
