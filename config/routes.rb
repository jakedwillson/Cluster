# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Default: public welcome page
  root 'welcome#index'
  get 'welcome/index'

  # Tasks
  get 'tasks/update'
  get 'tasks/index'
  get 'tasks/new'
  get 'tasks/show'
  get 'tasks/edit'
  get 'tasks/delete'
  get 'tasks/take'
  post 'tasks/mark_complete', to: 'tasks#mark_complete', as: 'mark_complete'
  post 'tasks/return_to_queue', to: 'tasks#return_to_queue', as: 'return_to_queue'
  get 'tasks/re_queue_task', to: 'tasks#re_queue_task', as: 're_queue_task'

  # Conversations
  get 'conversations/show'
  get 'conversations/find_or_create'
  get 'conversations/index'
  get 'conversations/new', to: 'conversations#new', as: 'new_conversation'
  get 'conversations/none', to: 'conversations#none', as: "no_conversations"

  # Messages
  get 'conversations/add_message', to: 'conversations#add_message', as: 'add_message'

  devise_for :users, controllers: { invitations: 'users/invitations', sessions: 'users/sessions' }

  # Home
  get 'home', to: 'home#show', as: 'home'

  resources :conversations do
    resources :messages
  end

  resources :sessions, only: [:new, :create, :destroy]

  get 'teams/show_info', to: 'teams#show_info', as: 'show_info'

  resources :teams do
    resources :invites
    resources :tasks
  end

  resources :tasks

  get 'accept_invite', to: 'invites#accept', as: 'accept_invite'
  get 'invites/new'

  resources :users do
    member do
      get :confirm_email
    end
  end

  # authentication routes
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  post 'sessions/user', to: 'sessions#create'

  # session routes
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
end
