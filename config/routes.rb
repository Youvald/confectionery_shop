Rails.application.routes.draw do
  # Маршрути Devise для аутентифікації
  devise_for :users, controllers: {
    sessions: 'sessions' # Переоприділяємо SessionsController
  }


  # Кореневий маршрут (головна сторінка)
  root "products#index"

  # Маршрути для продуктів і відгуків
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:create, :destroy]
  end

  # Маршрути для кошика
  resource :cart, only: [:show, :update] do
    member do
      delete :remove_item
      patch :update_quantity
    end
  end

  resources :orders, only: [:index, :show, :new, :create, :destroy] do
    member do
      patch :pay
    end
  end

  # Додаткові PWA маршрути (залиште, якщо вони потрібні)
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Перевірка стану додатку
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :admin do
    resources :products
    resources :orders, only: [:index, :show, :update]
    resources :reviews, only: [:index, :destroy]
  end
  resources :feedbacks, only: [:new, :create, :index]
  namespace :admin do
    resources :feedbacks, only: [:index] do
      member do
        patch :hide
      end
    end
  end
end
