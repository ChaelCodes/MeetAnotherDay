# frozen_string_literal: true

Rails.application.routes.draw do
  resources :event_attendees
  root "events#index"

  devise_for :users

  resources :events
  resources :profiles
  resources :users, except: :create
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
