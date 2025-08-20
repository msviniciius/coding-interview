require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :companies do
    resources :users, only: [:index]
  end

  resources :tweets, only: [:index]

  resources :users, param: :username, only: [:index, :show] do
    resources :tweets, only: [:index]
  end

  get "reports", to: "reports#index"
  post "reports/generate", to: "reports#generate", as: "generate_reports"
  get "reports/download/:id", to: "reports#download", as: "download_report"
end
