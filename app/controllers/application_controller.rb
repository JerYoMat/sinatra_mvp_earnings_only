require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'tbdsomethinglongandhardwhenitmatters'
  end

  get '/' do
    erb :index
  end

  helpers do
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end

    def authorized_user
        @loan && @loan.user == current_user
    end

    def required_fields_have_data
       params[:loan_amount] != "" &&  params[:loan_term] != "" && params[:annual_rate] != ""
    end

    def create_loan_from_form_data
      l = current_user.loans.build(loan_face_value: params[:loan_amount], loan_term: params[:loan_term], annual_rate: params[:annual_rate])
      l.total_amount = l.loan_term * l.monthly_payment
      l
    end



  end


end
