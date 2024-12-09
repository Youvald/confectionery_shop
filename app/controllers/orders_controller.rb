class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty, only: [:new, :create]

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.total_price = calculate_total_price
    @order.status = 'pending' # Статус за замовчуванням

    if @order.save
      save_order_items
      clear_cart
      redirect_to orders_path, notice: 'Ваше замовлення успішно оформлено!'
    else
      render :new, alert: 'Не вдалося оформити замовлення. Перевірте введені дані.'
    end
  end

  def destroy
    @order = current_user.orders.find(params[:id])

    if @order.status == 'pending'
      @order.destroy
      redirect_to orders_path, notice: 'Замовлення успішно відмінено.'
    else
      redirect_to orders_path, alert: 'Ви не можете відмінити це замовлення.'
    end
  end


  def index
    @orders = current_user.orders.includes(:order_items)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def pay
    @order = current_user.orders.find(params[:id])

    if @order.update(status: 'paid')
      redirect_to orders_path, notice: 'Замовлення успішно оплачено!'
    else
      redirect_to orders_path, alert: 'Не вдалося оплатити замовлення.'
    end
  end

  private

  def order_params
    params.require(:order).permit(:first_name, :last_name, :phone, :city, :street, :delivery_service)
  end


  def calculate_total_price
    current_user.cart.cart_items.sum { |item| item.product.price * item.quantity }
  end


  def save_order_items
    current_user.cart.cart_items.each do |item|
      @order.order_items.create(product: item.product, quantity: item.quantity, price: item.product.price)
    end
  end

  def clear_cart
    current_user.cart.cart_items.destroy_all
  end

  def ensure_cart_not_empty
    redirect_to cart_path, alert: 'Ваш кошик порожній. Додайте товари перед оформленням замовлення.' if current_user.cart.cart_items.empty?
  end

end
