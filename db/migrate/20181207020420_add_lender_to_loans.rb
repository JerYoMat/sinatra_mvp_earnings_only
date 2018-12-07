class AddLenderToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :lender, :string
  end
end
