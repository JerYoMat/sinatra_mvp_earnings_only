class LoansController < ApplicationController

  get '/loans' do
    if !logged_in?
      redirect to '/login'
    else
      # still need the loans of that user to load. 
      @loans = 4
      erb :'/loans/loans'
     end
  end


  get '/loans/new' do

  end

  post '/loans' do
  end

  get '/loans/:id' do
  end

  get 'loans/:id/edit' do
  end

  patch 'loans/:id' do
  end

end
