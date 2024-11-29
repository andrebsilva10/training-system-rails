Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "home#index"

  namespace :auth, as: "" do
    resource :session, only: %i[ new create destroy ]
    resources :passwords, param: :token, except: %i[ index show ]

    get "signup", to: "registrations#new", as: :new_registration
    post "signup", to: "registrations#create", as: :registration

    get "confirmation", to: "registrations#confirmation", as: :confirmation
    patch "confirm_account", to: "registrations#confirm_account"
    patch "resend_confirmation", to: "registrations#resend_confirmation"
  end

  namespace :users do
    root "home#dashboard"

    get "profile/edit", to: "profile#edit", as: :edit_profile
    patch "profile/update", to: "profile#update", as: :update_profile
    patch "profile/update_avatar", to: "profile#update_avatar", as: :update_avatar
    delete "profile/delete_avatar", to: "profile#delete_avatar", as: :delete_avatar
    get "profile/edit_password", to: "profile#edit_password", as: :edit_password
    patch "profile/update_password", to: "profile#update_password", as: :update_password
  end
end
