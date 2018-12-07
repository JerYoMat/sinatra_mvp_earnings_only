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

    def have_required_data?
       params[:loan_amount] != "" &&  params[:loan_term] != "" && params[:annual_rate] != ""
    end

    def required_data_valid?
       loan_amount = params[:loan_amount]
       loan_term = params[:loan_term]
       annual_rate = params[:annual_rate]
       conditions = [loan_amount.to_f > 0,
                     loan_term.to_f > 0,
                     annual_rate.to_f > 1]
# still need to add in check that input is a number

      let_pass = true
      conditions.each do |c|
         let_pass = false if c == false
      end
      let_pass
    end

    def create_loan_from_form_data
      l = current_user.loans.build(loan_face_value: params[:loan_amount], loan_term: params[:loan_term], annual_rate: params[:annual_rate])
      l.total_amount = l.loan_term * l.monthly_payment
      l
    end

    def update_loan_from_form_data
      @loan.update(loan_face_value: params[:loan_amount], loan_term: params[:loan_term], annual_rate: params[:annual_rate])
    end

    def find_this_loan
      @loan = Loan.find_by_id(params[:id])
    end

    def find_loans_belonging_to_user
      Loan.all.select do |l|
         l.user_id == current_user.id
      end
    end

  end


end
