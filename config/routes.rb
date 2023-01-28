Rails.application.routes.draw do
  get 'static/index'
  devise_for :users
  root to: "static#index"

  authenticated :user do
    root to: "dashboard#show", as: :user_root
    resources :groceries
    resources :meal_templates, only: [:show] do
      member do
        post :add_to_favorite
        post :remove_from_favorite
      end

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
      resources :ingredients
    end
    get "/groceries_search", to: "groceries#search", as: :search_groceries
  end
end
