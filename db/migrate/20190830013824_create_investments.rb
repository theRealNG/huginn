class CreateInvestments < ActiveRecord::Migration[5.2]
  def change
    create_table :investments do |t|
      t.decimal :amount, scale: 2, precision: 12
      t.string :investment_type
      t.boolean :tax_saving
      t.string :financial_year
      t.date :purchased_on
      t.string :account
      t.string :app
      t.decimal :units, scale: 4, precision: 12
      t.decimal :current_nav, scale: 4, precision: 12

      t.timestamps
    end
  end
end
