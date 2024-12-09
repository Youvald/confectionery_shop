class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)
    if @feedback.save
      redirect_to feedbacks_path, notice: 'Ваше повідомлення успішно відправлено.'
    else
      flash.now[:alert] = 'Не вдалося відправити повідомлення. Перевірте введені дані.'
      render :new
    end
  end

  def index
    @feedbacks = current_user.feedbacks.order(created_at: :desc)
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content)
  end
end
