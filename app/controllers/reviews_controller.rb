class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: :destroy
  before_action :authorize_review, only: :destroy

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to product_path(@product), notice: 'Ваш відгук успішно додано!'
    else
      redirect_to product_path(@product), alert: 'Не вдалося додати відгук. Перевірте введені дані.'
    end
  end

  def destroy
    @review.destroy
    redirect_to product_path(@review.product), notice: 'Відгук успішно видалено.'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def authorize_review
    unless @review.user == current_user || current_user.admin?
      redirect_to product_path(@review.product), alert: 'Ви не маєте прав для видалення цього відгуку.'
    end
  end

  def review_params
    params.require(:review).permit(:content, :reaction)
  end
end
