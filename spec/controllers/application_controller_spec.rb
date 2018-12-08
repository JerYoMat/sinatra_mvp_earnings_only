require_all 'spec'
require 'pry'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to PaymentCalc")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to loans summary' do
      params = {
        :username => "skittles123",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/loans")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
      params = {
        :username => "skittles123",
        :password => "rainbows"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/loans')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the loans summary page after login' do
      user = User.create(:username => "becky567", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Loan Amount")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/loans")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /loans if user not logged in' do
      get '/loans'
      expect(last_response.location).to include("/login")
    end

    it 'does load /loans if user is logged in' do
      user = User.create(:username => "becky567", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/loans')
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new loan form if logged in' do
        user = User.create(:username => "becky567", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/loans/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a loan if they are logged in' do
        user = User.create(:username => "becky567", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/loans/new'
        fill_in(:lender, :with => "testbank")
        fill_in(:loan_amount, :with => 1000)
        fill_in(:loan_term, :with => 12)
        fill_in(:annual_rate, :with => 10)

        click_button 'submit'

        user = User.find_by(:username => "becky567")
        loan = Loan.find_by(:lender => "testbank")
        expect(loan).to be_instance_of(Loan)
        expect(loan.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create loans from another user' do
        user = User.create(:username => "becky567", :password => "kittens")
        user2 = User.create(:username => "silverstallion",  :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/loans/new'

        fill_in(:lender, :with => "testbank2")
        fill_in(:loan_amount, :with => 1000)
        fill_in(:loan_term, :with => 12)
        fill_in(:annual_rate, :with => 10)
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        loan = Loan.find_by(:lender => "testbank2")
        expect(loan).to be_instance_of(Loan)
        expect(loan.user_id).to eq(user.id)
        expect(loan.user_id).not_to eq(user2.id)
      end
#Actually should be checking that all the reqs have been entered by leaving each field blank.  Just checking loan amount for now.
      it 'does not let a user create a blank loan' do
        user = User.create(:username => "becky567",  :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/loans/new'

        fill_in(:loan_amount, :with => "")
        click_button 'submit'

        expect(Loan.find_by(:loan_face_value => "")).to eq(nil)
        expect(page.current_path).to eq("/loans/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new loan form if not logged in' do
        get '/loans/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single loan' do

        user = User.create(:username => "becky567", :password => "kittens")
        loan = Loan.create(:loan_face_value => 2000, :loan_term => 36, :annual_rate => 12, :lender => "TestBank3", :user_id => user.id)


        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/loans/#{loan.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete")
        expect(page.body).to include(loan.lender)
        expect(page.body).to include("edit")
      end
    end

    context 'logged out' do
      it 'does not let a user view a loan' do
        user = User.create(:username => "becky567",  :password => "kittens")
        loan = Loan.create(:loan_face_value => 2000, :loan_term => 36, :annual_rate => 12, :lender => "TestBank4", :user_id => user.id)
        get "/loans/#{loan.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view loan edit form if they are logged in' do
        user = User.create(:username => "becky567", :password => "kittens")
        loan = Loan.create(:loan_face_value => 2000, :loan_term => 36, :annual_rate => 12, :lender => "TestBank5", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/loans/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(loan.lender)
      end

      it 'does not let a user edit a loan they did not create' do
        user1 = User.create(:username => "becky567",  :password => "kittens")
        loan1 = Loan.create(:loan_face_value => 3000, :loan_term => 12, :annual_rate => 10, :lender => "TestBankUser1", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :password => "horses")
        loan2 = Loan.create(:loan_face_value => 4000, :loan_term => 24, :annual_rate => 8, :lender => "TestBankUser2", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/loans/#{loan2.id}/edit"
        expect(page.current_path).to include('/')
      end

      it 'lets a user edit their own loan if they are logged in' do
        user = User.create(:username => "becky567",  :password => "kittens")
      loan = Loan.create(:loan_face_value => 2000, :loan_term => 36, :annual_rate => 12, :lender => "TestBank6", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/loans/#{loan.id}/edit"

        fill_in(:lender, :with => "Lender Changed")

        click_button 'submit'

        expect(Loan.find_by(:lender => "Lender Changed")).to be_instance_of(Loan)
        expect(Loan.find_by(:lender =>"TestBank6")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "becky567", :password => "kittens")
        loan = Loan.create(:loan_face_value => 2999, :loan_term => 36, :annual_rate => 12, :lender => "TestBank7", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/loans/#{loan.id}/edit"
        loan_id = loan.id
        fill_in(:loan_amount, :with => "")

        click_button 'submit'
        check_loan = Loan.find(loan_id)
        expect(check_loan.loan_face_value).to  eq(2999)
        expect(page.current_path).to eq("/loans")
      end
    end

    context "logged out" do
      it 'does not load -- instead redirects to login' do
        get '/tweets/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own tweet if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'tweets/1'
        click_button "Delete Tweet"
        expect(page.status_code).to eq(200)
        expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)
      end

      it 'does not let a user delete a tweet they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        tweet1 = Tweet.create(:content => "tweeting!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        tweet2 = Tweet.create(:content => "look at this tweet", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "tweets/#{tweet2.id}"
        click_button "Delete Tweet"
        expect(page.status_code).to eq(200)
        expect(Tweet.find_by(:content => "look at this tweet")).to be_instance_of(Tweet)
        expect(page.current_path).to include('/tweets')
      end
    end

    context "logged out" do
      it 'does not load let user delete a tweet if not logged in' do
        tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
        visit '/tweets/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end
end
