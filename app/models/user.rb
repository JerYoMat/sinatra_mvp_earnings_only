class User < ActiveRecord::Base
  has_many :loans
  validates :username, :password, presence: true
  has_secure_password
end
