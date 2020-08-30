Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'public/users/sessions',
    passwords: 'public/users/passwords',
    registrations: 'public/users/registrations',
  }
  scope module: :public do
    root 'homes#top'
    resources :events, only: [:show, :index]
    resources :users, only: [:show, :edit, :index, :update] do
      resource :relationships, only: [:create, :destroy]
      get :follows, on: :member
      get :followers, on: :member
    end
    resources :rooms, only: [:show, :index]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
  end

  namespace :admin do
    resources :users, only: [:show] do
      resources :todos, only: [:create, :destroy]
    end
    resources :events, only: [:show, :index, :edit, :create, :update, :destroy]
    get 'step1', to: 'events#step1'
    post 'step2', to: 'events#step2'
    get 'step3', to: 'events#step3'
    post 'step4', to: 'events#step4'
    post 'confirm', to: 'events#confirm'

    get 'events/:event_id/send_remind', to: 'events#send_remind', as: 'events_send_remind'
    patch 'events/:event_id/progress_status_update', to: 'events#progress_status_update', as: 'events_progress_status'
    get 'events/:event_id/notice_to_unpaying_users', to: 'events#notice_to_unpaying_users', as: 'notice_to_unpaying_users'
    get 'events/:event_id/add_event_user', to: 'events#add_event_user', as: 'add_event_user'
    post 'events/:event_id/add_event_user_fee', to: 'events#add_event_user_fee', as: 'add_event_user_fee'
    post 'events/:event_id/add_event_user', to: 'events#add_event_user_create', as: 'add_event_user_create'
    get 'events/:event_id/change_restaurant', to: 'events#change_restaurant', as: 'change_restaurant'
    patch 'event_users/:event_user_id/fee_status', to: 'event_users#fee_status_update', as: 'event_users_fee_status'
    patch 'event_users/:event_user_id/fee', to: 'event_users#fee_update', as: 'event_users_fee'
    patch 'event_users/:event_user_id/participate_status', to: 'event_users#participate_status_update', as: 'event_users_participate_status'

    resources :rooms, only: [:show, :index]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
  end
end
