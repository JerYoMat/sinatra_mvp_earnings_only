require './config/environment'
class User < ActiveRecord::Base
  has_many :income_statement_line_items

  validates :username, :password, presence: true
  has_secure_password

    def self.create_from_form(params)
      User.create(:username => params[:username], :password => params[:password])
    end

end
