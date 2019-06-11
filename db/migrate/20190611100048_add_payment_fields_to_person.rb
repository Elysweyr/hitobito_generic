class AddPaymentFieldsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :payment_method, :string, default: 'bar'
    add_column :people, :iban, :string, limit: 34
    add_column :people, :bic, :string, limit: 11
    add_column :people, :account_holder, :string
  end
end
