Rails.application.routes.draw do

  # devise_for :agencies
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :orders

  # Agency Pages
  Rails.application.routes.draw do
    devise_for :agency, controllers: {
      sessions: 'agency/sessions',
      passwords: 'agency/passwords',
      registrations: 'agency/registrations',
      confirmations: 'agency/confirmations',
      unnlocks: 'agency/unlocks'
    }
  end

  get 'agency/:id/inbox', to: "agency_panel#inbox", :as => :agency_inbox
  get 'agency-request-account', to: 'shyft_pages#agency_request_account', :as => :agency_account

  # root 'shyft_pages#home'
  root 'shyft_pages#home'

  # Static Pages for the Site
  get 'invite'              => 'shyft_pages#request_invite'
  get 'how-to-hire'         => 'shyft_pages#how_to_hire'
  get 'how-to-work'         => 'shyft_pages#how_to_work'
  get 'why-shyft'           => 'shyft_pages#why_shyft'
  get 'home-alternate'      => 'shyft_pages#home_alternate'
  get 'cphollister'         => 'shyft_pages#cphollister_profile'
  get 'book_cphollister'    => 'shyft_pages#cphollister_booking'
  get 'create_event'    => 'shyft_pages#create_event'
  get 'confirm_booking'     => 'shyft_pages#confirmation'
  get 'agency_waitlist'     => 'shyft_pages#agency_waitlist'
  get 'agency_request_account'  => 'shyft_pages#agency_request_account'
  get 'error_booking'       => 'shyft_pages#booking_error'
  get 'check_email'         => 'ambassadors#check_email'
  get 'agency_waitlist'     => 'shyft_pages#agency_waitlist'

  # Legal Pages
  get 'terms-of-use',         to: 'legal_docs#terms_of_use'
  get 'privacy-policy',       to: 'legal_docs#privacy_policy'
  get 'event-rules',          to: 'legal_docs#event_rules'
  get 'cancellation-policy',  to: 'legal_docs#cancellation_policy'
  get 'refund-policy',        to: 'legal_docs#refund_policy'

  # Ambassador Specific Pages
  get 'ambassadors_signup' => 'ambassadors#new'
  get 'ambassadors_search', to: 'ambassadors#index'

  # Ambassador Session Specific Pages
  get 'ambassador_sessions/new'
  get 'login'       => 'ambassador_sessions#new'
  post 'login'      => 'ambassador_sessions#create'
  delete 'logout'   => 'ambassador_sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  get 'password_resets/new'
  get 'ambassador_password_reset' =>'password_resets#reset'

  # For error pages
  %w( 404 422 500 503 ).each do |code|
    get code => "errors#show", :code => code
  end
  # Form emailing

  # Twilio Phone Verification
  resources :phone_numbers, only: [:new, :create]
  post 'phone_numbers/verify' => "phone_numbers#verify"

  resources :images

  # Session Specific Pages
  get 'sessions/new'

  resources :ambassadors
  resources :line_items
  resources :carts
  resources :ambassador_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :order,     except: :index
  resources :contacts, only: [:new, :create]
  resources :bookings, only:[:new, :create, :edit, :index, :show, :update] do
    member do
      get :book_request_accept_confirm
      get :book_request_decline_confirm
    end
  end

  # resources :agency do
  resources :events, only: [:new, :create, :edit, :index, :show, :update] do
    resources :event_locations, only: [:new, :create, :update]
    resources :conversations, only:[:index]
  end
  delete "/events/:id", to: "events#destroy", as: "delete_event"
  get 'events/shortList', to: 'events#shortList'
  get 'new_event_session', to: 'events#new_event_session'

  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end
  get 'contacts' => 'contacts#new'
  post 'contacts' => 'contacts#create'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  #Ambassador Dashboard
  get 'dashboard', to: 'dashboard#index'
  post 'dashboard/cancel_booking', to: 'dashboard#cancel_booking', as: :cancel_booking

  #Ambassador Busy Shifts
  get 'busyShifts', to:'busy_shift#index'
  get 'busyShifts/new', to: 'busy_shift#new', as: 'new_busy_shift'
  post 'busyShifts', to: 'busy_shift#create', as: 'busy_shifts'
  get 'busyShifts/:id/edit', to: 'busy_shift#edit', as: 'edit_busy_shifts'
  patch 'busyShift/:id', to: 'busy_shift#update'
  delete 'busyShift/:id', to: 'busy_shift#destroy'

  #Creating Shifts and Roles from Event Dates
  get 'roleTypes/', to: 'shifts_role#roleTypes'
  get 'roleStatusList/', to: 'shifts_role#roleStatusList'
  get 'shiftsByDate/', to: 'shifts_role#shiftsByDate'
  get 'rolesByShift/', to: 'shifts_role#rolesByShift'
  post 'shifts/create', to: 'shifts_role#createShift'
  post 'shifts/createRole', to: 'shifts_role#createRoleForShift'
  patch 'shifts/role/:role_id', to: 'shifts_role#changeRoleForShift'
  delete 'shifts/:shift_id', to: 'shifts_role#destroyShift'
  delete 'roles/:role_id', to: 'shifts_role#destroyRole'

  patch 'shortList/add', to: 'shifts_role#shortList'
  delete 'shortList/removeAmbassador', to: 'shifts_role#remove_ambassador_from_short_list'

  get 'shortList/book', to: 'short_lists#submit'

  #Event Dates
  get 'eventDate', to: 'event_dates#datesByLocation'
  get 'eventDate/shifts', to: 'event_dates#shiftsByDateId'
  get 'eventDate/new', to: 'event_dates#new', as: 'new_event_dates'
  post 'eventDate/create', to: 'event_dates#create', as: 'event_dates'
  patch 'eventDate/:id', to: 'event_dates#update'
  delete 'eventDate/id', to: 'event_dates#destroy'

  #Fake Filter Query
  get 'test', to: 'filter_ambassadors#test'
  get 'filterAmbassadors/', to: 'filter_ambassadors#filter'
  get 'filterAmbassadorsIndex/', to: 'filter_ambassadors#filter_index'
  get 'filterForRole/', to: 'filter_ambassadors#fitler_by_role'
  get 'getShortListedAmbassadors/', to: 'filter_ambassadors#short_listed_ambassadors'

  namespace :api, defaults: {format: :json} do
    resources :events, only: [:update, :new, :index, :create, :show, :destroy]
    resources :event_locations, only: [:create, :new, :update, :index, :show, :destroy]
    resources :event_dates, only: [:create, :new, :update, :index, :show, :destroy]
  end
end
