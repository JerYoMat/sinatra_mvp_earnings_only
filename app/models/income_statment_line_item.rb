require './config/environment'
class IncomeStatementLineItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
end
