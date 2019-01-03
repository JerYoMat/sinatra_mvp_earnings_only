class CreatePaychecks < ActiveRecord::Migration
  def change
    create_table :paychecks do |t|
      t.belongs_to :user
      t.float :medical
      t.float :fsa
      t.float :federal_taxes
      t.float :state_taxes
      t.float :city_taxes
      t.float :ss_medicare_and_other
      t.float :pre_tax_earnings
      t.float :take_home_pay
      t.float :annual_salary
      t.integer :payments_per_month
      t.timestamps
    end
  end

end
