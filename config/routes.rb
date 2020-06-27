Rails.application.routes.draw do

  root "items#index"

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    omniauth_callbacks:  "users/omniauth_callbacks"
  }

  devise_scope :user do
    ## ↓登録方法の選択ページ
    get "users/select_registration", to: 'users/registrations#select', as: :select_registration
    ## ↓電話番号認証ページ
    get "users/confirm_phone", to: 'users/registrations#confirm_phone', as: :confirm_phone
    ## ↓電話番号認証送信したとき
    post "users/pre_phone", to: 'users/registrations#pre_phone', as: :pre_phone
    ## ↓addressの登録ページ
    get "users/regist_address", to: 'users/registrations#new_address', as: :new_regist_address
    ## ↓addressのcreate
    post "users/regist_address", to: 'users/registrations#create_address', as: :regist_address
    ## ↓cardの登録ページ
    get "users/regist_payment", to: 'users/registrations#new_payment', as: :new_regist_payment
    ## ↓登録完了ページ
    get "users/regist_completed", to: 'users/registrations#completed', as: :regist_completed
  end
  
  resources :items do
    resource :purchases, only: %i(new create)
    member do
      get "purchase_confirmation"
      post "purchase"
    end
  end

  resources :categories, only: %i(index show)

  resources :item_searches, only: %i(index)

  resources :users, only: %i(show)

  resource :cards, only: %i(new create show update destroy)

  namespace :api do
    resources :items, only: [:create, :update], defaults: { format: 'json' }
    resources :categories, only: %i(index), defauluts: { format: 'json'}
  end
  
end
