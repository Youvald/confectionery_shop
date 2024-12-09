class AddDetailsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :phone, :string
    add_column :orders, :city, :string
    add_column :orders, :street, :string
  end
end
