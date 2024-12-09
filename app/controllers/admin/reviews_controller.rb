class Admin::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @reviews = Review.includes(:user, :product).order(created_at: :desc)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to admin_reviews_path, notice: 'Відгук успішно видалено.'
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: 'Доступ заборонено!' unless current_user.admin?
  end
end
