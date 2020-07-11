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
    resources :users, only: [:show, :destroy] 
    # 下記メンバー仕様のルーティングに変更要
    resources :events, only: [:show, :index, :edit, :create, :update, :destroy]
    get 'events/progress_status_update'
    get 'events/fee_status_update'
    get 'events/confirm_plan_remind'
    get 'events/send_plan_remind'
    get 'events/step1'
    get 'events/step2'
    get 'events/confirm'
    get 'event_users/fee_status_update'
    resources :rooms, only: [:show, :index]
    resources :direct_messages, only: [:create]
    resources :notifications, only: [:index, :destroy]
    resources :searches, only: [:find_restaurant, :find_member]
  end
end