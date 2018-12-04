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
     if logged_in?
       erb :'loans/create_loan'
     else
       redirect to '/login'
     end
  end

  post '/loans' do
    if logged_in?
      if params[:loan_amount] != "" && params[:origination_fees] != "" && params[:loan_term] != "" && params[:annual_rate] != ""
        @loan = current_user.loans.build(loan_face_value: params[:loan_amount], loan_present_value: params[:origination_fees], loan_term: params[:loan_term], annual_rate: params[:annual_rate])
          if @loan.save
            redirect to "/loans/#{@loan.id}"
          else
            redirect to '/loans/new'
          end
        else
          redirect to '/loans/new'
        end
     else
      redirect to '/login'
    end

  end

  get '/loans/:id' do
  end

  get 'loans/:id/edit' do
  end

  patch 'loans/:id' do
  end

end
