class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  after_create :create_cart
  enum role: { guest: 'guest', client: 'client', admin: 'admin' }
  after_initialize :set_default_role, if: :new_record?
  has_many :reviews, dependent: :destroy
  def create_cart
    Cart.create(user: self) unless self.cart.present?
  end

  def admin?
    role == 'admin'
  end
  private


  def set_default_role
    self.role ||= :client
  end
end
