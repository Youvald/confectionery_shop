class Admin::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @feedbacks = Feedback.where(hidden_for_admin: false).order(created_at: :desc)
  end

  def hide
    feedback = Feedback.find(params[:id])
    feedback.update(hidden_for_admin: true)
    redirect_to admin_feedbacks_path, notice: 'Повідомлення приховано для адміністратора.'
  end

  private

  def check_admin!
    redirect_to root_path, alert: 'Ви не маєте доступу до цієї сторінки.' unless current_user.admin?
  end
end
