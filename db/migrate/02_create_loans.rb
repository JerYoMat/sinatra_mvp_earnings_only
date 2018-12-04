class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.belongs_to :user
      t.integer :loan_face_value
      t.integer :loan_present_value
      t.integer :loan_term
      t.integer :annual_rate
      t.timestamps
    end
  end

end
