class Loan < ActiveRecord::Base
  belongs_to :user
=begin
#for when in irb

attr_accessor :loan_face_value, :loan_present_value, :loan_term, :annual_rate
=end
  def periodic_rate
    decimal = self.annual_rate / 100
    periodic_rate = decimal / 12
    periodic_rate
  end




  def monthly_payment
    r = self.periodic_rate
    pv = self.loan_face_value
    n = self.loan_term

    numerator = r * pv
    rplusone = r + 1
    exponent = n * (-1)
    almostdenominator = rplusone ** exponent
    denominator = 1 - almostdenominator
    p = numerator / denominator

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
