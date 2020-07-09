Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions:      'public/users/sessions',
    passwords:     'public/users/passwords',
    registrations: 'public/users/registrations'
  }
  scope module: :public do
    root 'homes#top'
    resources :events, only: [:show, :index]
    resources :users, only: [:show, :edit, :index]
    resources :relationships, only: [:create, :destroy]
    resources :rooms, only: [:show, :index, :create]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
    resources :searches, only: [:find_user, :find_member]
  end

  namespace :admin do
    resources :users, only: [:show, :destroy]
    get 'events/progress_status_update' => "events#progress_status_update"
    get 'events/fee_status_update'
    get 'events/confirm_plan_remind'
    get 'events/send_plan_remind'
    get 'events/step1'
    get 'events/step2'
    get 'events/confirm'
    resources :events, only: [:show, :index, :edit, :create, :update, :destroy]
    get 'event_users/fee_status_update'
    resources :rooms, only: [:show, :index, :create]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
    resources :searches, only: [:find_restaurant, :find_member]
  end
end