class Loan < ActiveRecord::Base
  belongs_to :user
=begin
#for when in irb

attr_accessor :loan_face_value, :loan_present_value, :loan_term, :annual_rate
=end
  def periodic_rate
    self.annual_rate / 12
  end

  def origination_fees
    self.loan_face_value - self.loan_present_value
  end


  def monthly_payment
    r = self.periodic_rate
    pv = self.loan_present_value
    n = self.loan_term

    numerator = r * pv
    rplusone = r + 1
    exponent = n * (-1)
    almostdenominator = rplusone ** exponent
    denominator = 1 - almostdenominator
    numerator / denominator
  end

end
=begin
p = .87915887230009850
l = Loan.new
l.loan_face_value = 10
l.loan_present_value = 10
l.loan_term = 12
l.annual_rate = 0.1
=end
