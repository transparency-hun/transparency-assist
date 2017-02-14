# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'impressum' => 'static_pages#impressum', :as => :impressum
  get 'legal_notice' => 'static_pages#legal_notice', :as => :legal_notice
  get 'manual' => 'static_pages#manual', :as => :manual
  get 'about' => 'static_pages#about', :as => :about

  get 'index' => 'main_page#index'
  get 'show' => 'main_page#show'

  get 'download' => 'data_tables#download', :as => :download
  get 'show_preview_with_diff' => 'data_tables#show_preview_with_diff', :as => :show_preview_with_diff

  resource :data_table, only: [:new, :create]

  resources :data_sources, only: [] do
    member do
      get 'download'
      get 'download_diff'
    end
  end

  root to: 'main_page#index'
end
