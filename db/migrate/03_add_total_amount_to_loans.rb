class AddTotalAmountToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :total_amount, :integer  
  end
end
