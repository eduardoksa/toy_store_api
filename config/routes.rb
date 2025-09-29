Rails.application.routes.draw do
  post "/login", to: "auth#login"

  resources :clients, only: [ :index, :create, :update, :destroy, :show ] do
    collection do
      post :import
    end
  end
  resources :sales, only: [ :create, :show ]

  get "/statistics/sales_per_day", to: "statistics#sales_per_day"
  get "/statistics/client_metrics", to: "statistics#client_metrics"
end
