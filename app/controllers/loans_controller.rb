class LoansController < ApplicationController

  get '/loans' do
    if !logged_in?
      redirect to '/login'
    else
      @loans = Loan.all.select do |l|
         l.user_id == current_user.id
      end
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
        @loan = current_user.loans.build(loan_face_value: params[:loan_amount], loan_term: params[:loan_term], annual_rate: params[:annual_rate])
        @loan.total_amount = @loan.loan_term * @loan.monthly_payment
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
    if logged_in?
      @loan = Loan.find_by_id(params[:id])
      if authorized_user
        erb :'loans/show_loan'
      else
        redirect to '/'
      end
    else
      redirect to '/login'
    end
  end

 get '/loans/:id/edit'do
    if logged_in?
      @loan = Loan.find_by_id(params[:id])
      if authorized_user
        erb :'loans/edit_loan'
      else
        redirect to '/'
      end
    else
      redirect to '/login'
    end
  end

  patch '/loans/:id' do
    if logged_in?
        if params[:loan_amount] != "" && params[:origination_fees] != "" && params[:loan_term] != "" && params[:annual_rate] != ""
          @loan = Loan.find_by_id(params[:id])
          if authorized_user
            if @loan.update(loan_face_value: params[:loan_amount], loan_term: params[:loan_term], annual_rate: params[:annual_rate])
              redirect to "/loans/#{@loan.id}"
            else
              redirect to "/loans/#{@loan.id}/edit"
            end
          else
            redirect to '/loans'
          end
        else
          redirect to '/loans/:id/edit'
        end
    else
      redirect to '/login'
    end
  end

  delete '/loans/:id/delete' do
    if logged_in?
      @loan = Loan.find_by_id(params[:id])
      if authorized_user
        @loan.delete
      end
      redirect to '/loans'
    else
      redirect to '/login'
    end
  end

end
