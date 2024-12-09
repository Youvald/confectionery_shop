class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @products = Product.order(:name).page(params[:page]).per(15) # Використання пагінації kaminari
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: 'Товар успішно створено.'
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path, notice: 'Товар успішно оновлено.'
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path, notice: 'Товар успішно видалено.'
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category, :image, :weight)
  end

  def ensure_admin!
    redirect_to root_path, alert: 'Доступ заборонено!' unless current_user.admin?
  end
end
