class Loan < ActiveRecord::Base
  belongs_to :user

  def periodic_rate
  end

end
