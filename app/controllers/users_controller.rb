require 'pry'
class UsersController < ApplicationController


  get '/login' do
    if logged_in?
      @user = current_user
      redirect to '/loans'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/loans'
    else
      redirect to '/signup'
    end
  end


  get '/signup' do
    if !logged_in?
      erb :'users/signup'
    else
      redirect to '/loans'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == ""
       redirect to '/signup'
    elsif User.find_by(:username => params[:username])
      redirect to '/signup'
    else
       @user = User.create_from_form(params)
       session[:user_id] = @user.id
       redirect to '/loans'
     end
  end



  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/signup'
    end
  end

end
