class AddHiddenForAdminToFeedbacks < ActiveRecord::Migration[7.2]
  def change
    add_column :feedbacks, :hidden_for_admin, :boolean
  end
end
