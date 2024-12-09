class ProductsController < ApplicationController
  def index
    @products = Product.all

    # Фільтрація
    @products = filter_products(@products)

    # Пагінація
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user)
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Товар не знайдено.'
  end

  private

  def filter_products(products)
    products = products.where(category: params[:category]) if params[:category].present?
    products = products.where('price >= ?', params[:min_price]) if params[:min_price].present?
    products = products.where('price <= ?', params[:max_price]) if params[:max_price].present?
    products = products.where('stock > 0') if params[:availability] == 'in_stock'
    products
  end
end
