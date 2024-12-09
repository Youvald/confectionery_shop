class AddDeliveryServiceToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :delivery_service, :string
  end
end
