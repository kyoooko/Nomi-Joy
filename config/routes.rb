Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions:      'public/users/sessions',
    passwords:     'public/users/passwords',
    registrations: 'public/users/registrations'
  }
  scope module: :public do
    root 'homes#top'
    resources :events, only: [:show, :index]
    resources :users, only: [:show, :edit, :index,:update] do
      resource :relationships, only: [:create, :destroy]
      get :follows, on: :member 
      get :followers, on: :member 
    end
    resources :rooms, only: [:show, :index]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
    # 下記いらない？
    # get 'searches/find_member'
    get 'searches/find_user'
  end

  namespace :admin do
    resources :users, only: [:show] 
    # 下記メンバー仕様のルーティングに変更要
    resources :events, only: [:show, :index, :edit, :create, :update, :destroy]
    get 'step1',to:'events#step1'
    get 'step2',to:'events#step2'
    get 'confirm',to:'events#confirm'
    get 'events/confirm_plan_remind'
    get 'events/send_plan_remind'
    patch 'events/:event_id/progress_status_update',to:'events#progress_status_update', as: 'events_progress_status'
    patch 'event_users/:event_user_id/fee_status',to:'event_users#fee_status_update', as: 'event_users_fee_status'
    patch 'event_users/:event_user_id/fee',to:'event_users#fee_update', as: 'event_users_fee'
    patch 'event_users/:event_user_id/participate_status',to:'event_users#participate_status_update', as: 'event_users_participate_status'
    resources :rooms, only: [:show, :index]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
    resources :searches, only: [:find_restaurant, :find_member]
  end
end