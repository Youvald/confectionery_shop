class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @orders = Order.includes(:order_items, :user).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
      redirect_to admin_orders_path, notice: 'Статус замовлення оновлено.'
    else
      redirect_to admin_orders_path, alert: 'Не вдалося оновити статус замовлення.'
    end
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: 'Доступ заборонено!' unless current_user.admin?
  end
end
