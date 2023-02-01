Rails.application.routes.draw do
  get 'static/index'
  devise_for :users
  root to: "static#index"

  authenticated :user do
    root to: "dashboard#show", as: :user_root
    resources :groceries
    resources :commands
    resources :meal_templates, only: [:show] do
      resources :favorite_meal_templates, only: [:create, :destroy]

      collection do
        get :search
        get :autocomplete
      end
    end
    resources :meals do
      collection do
        get :load_templates
        post :create_from_template
      end
      resources :ingredients, only: [:create, :destroy, :update]
    end
    get "/groceries_search", to: "groceries#search", as: :search_groceries
  end
end
