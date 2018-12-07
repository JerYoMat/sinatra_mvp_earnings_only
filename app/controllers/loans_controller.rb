class LoansController < ApplicationController

  get '/loans' do
    if !logged_in?
      redirect to '/login'
    else
      @loans = find_loans_belonging_to_user
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
      if have_required_data? && required_data_valid?
        @loan = create_loan_from_form_data
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
      find_this_loan
      if authorized_user?
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
      find_this_loan
      if authorized_user?
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
        if required_fields_have_data
          find_this_loan
          if authorized_user?
            if update_loan_from_form_data
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
      find_this_loan
      if authorized_user?
        @loan.delete
      end
      redirect to '/loans'
    else
      redirect to '/login'
    end
  end

end
