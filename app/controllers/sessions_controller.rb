class SessionsController < Devise::SessionsController
  # Додайте ваші методи чи перевизначення тут

  # Дія викликається перед входом користувача
  before_action :store_guest_cart, only: :create

  # Дія викликається після успішного входу користувача
  after_action :merge_guest_cart_with_user_cart, only: :create

  private

  # Збереження сесійного кошика
  def store_guest_cart
    @guest_cart = session[:cart] if session[:cart].present?
  end

  # Злиття сесійного кошика з кошиком авторизованого користувача
  def merge_guest_cart_with_user_cart
    return unless @guest_cart

    @guest_cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product

      # Додаємо товари до кошика авторизованого користувача
      cart_item = current_user.cart.cart_items.find_or_initialize_by(product: product)
      cart_item.quantity = (cart_item.quantity || 0) + quantity
      cart_item.save
    end

    # Очищаємо сесію після перенесення
    session.delete(:cart)
  end
end
