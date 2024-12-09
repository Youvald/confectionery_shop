class CartsController < ApplicationController
  before_action :set_cart

  def show
    if user_signed_in?
      @cart_items = current_user.cart.cart_items.includes(:product).map do |item|
        if item.product.present?
          { product: item.product, quantity: item.quantity }
        else
          item.destroy
          nil
        end
      end.compact
    else
      @cart_items = []
      if session[:cart].present?
        Product.where(id: session[:cart].keys).each do |product|
          if product.present?
            @cart_items << { product: product, quantity: session[:cart][product.id.to_s] }
          end
        end
      end
    end
  end

  def update
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if user_signed_in?
      # Знайти або створити об'єкт у кошику
      item = @cart.cart_items.find_or_initialize_by(product: product)
      # Ініціалізувати кількість, якщо вона ще не встановлена
      item.quantity ||= 0
      # Збільшити кількість
      item.quantity += quantity
      item.save
    else
      # Для неавторизованих користувачів (зберігається в сесії)
      session[:cart] ||= {}
      session[:cart][product.id.to_s] = (session[:cart][product.id.to_s] || 0) + quantity
    end

    redirect_to cart_path, notice: "Товар додано до кошика!"
  end


  def update_quantity
    product = Product.find(params[:product_id])
    new_quantity = params[:quantity].to_i

    if user_signed_in?
      item = @cart.cart_items.find_by(product: product)
      if item
        item.update(quantity: new_quantity)
      end
    else
      session[:cart][product.id.to_s] = new_quantity if session[:cart][product.id.to_s]
    end

    redirect_to cart_path, notice: "Кількість товару оновлено."
  end

  def remove_item
    product = Product.find(params[:product_id])

    if user_signed_in?
      @cart.cart_items.find_by(product: product)&.destroy
    else
      session[:cart].delete(product.id.to_s) if session[:cart]
    end

    redirect_to cart_path, notice: "Товар видалено з кошика."
  end

  private

  def set_cart
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
    else
      @cart = Cart.new
    end
  end
end
