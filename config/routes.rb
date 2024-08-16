Rails.application.routes.draw do
  mount API::Base => "/"
  root "main#index"
  get "/invite" => "main#invite"
  get "/leads" => "main#leads"
  post "/leads" => "main#leads"

  get "/admin" => "admin/login#new"
  post "/admin" => "admin/login#login"
  delete "/admin/logout" => "admin/login#logout"
  get "/admin/dashboard" => "admin/dashboard#index"
  namespace :admin do
    resources :users do
      put "/lead" => "users#lead"
    end
    resources :offers
    resources :payouts
    resources :videos
    resources :app_banners
    post "/payout_user/:id", to: "admin#payout", as: "payout_user"
  end
end
