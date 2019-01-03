require './config/environment'

class Account < ActiveRecord::Base
  has_many :income_statement_line_items
  has_many :users, through: :income_statement_line_items
end
