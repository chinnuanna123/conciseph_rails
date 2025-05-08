Rails.application.routes.draw do
  resources :chronic_condition_management_goals do
    member do
      get 'launch', to: 'chronic_condition_management_goals#launch'
      get 'review', to: 'chronic_condition_management_goals#review'
    end
  end
  resources :care_managements do
    member do
      get 'launch', to: 'care_managements#launch'
      get 'review', to: 'care_managements#review'
    end
  end
  resources :custom_templates
  resources :overseers do
    member do
      resources :api_logs, only: %i[index]
    end
    get 'api_logs/:id' => 'api_logs#show'
  end
  resources :chronic_condition_managements, :only=>[:index] do
    collection do
      get 'medication_adherence' => 'chronic_condition_managements#medication_adherence'
      get 'medication_refills' => 'chronic_condition_managements#medication_refills'
      get 'health_education' => 'chronic_condition_managements#health_education'
      get 'nutrition_therapy' => 'chronic_condition_managements#nutrition_therapy'
      get 'health_events' => 'chronic_condition_managements#health_events'
      get 'feedbacks' => 'chronic_condition_managements#feedbacks'
      get 'hb1ac' => 'chronic_condition_managements#hb1ac'
      get 'schedule_adherence' => 'chronic_condition_managements#schedule_adherence'
    end
  end
  resources :timely_recovery_goals do
    member do
      get 'launch', to: 'timely_recovery_goals#launch'
      get 'review', to: 'timely_recovery_goals#review'
    end
  end
  resources :member_feedbacks do
    member do
      get 'launch', to: 'member_feedbacks#launch'
      get 'review', to: 'member_feedbacks#review'
    end
  end
  resources :health_events do
    member do
      get 'launch', to: 'health_events#launch'
      get 'review', to: 'health_events#review'
    end
  end
  resources :health_educations do
    member do
      get 'launch', to: 'health_educations#launch'
      get 'review', to: 'health_educations#review'
    end
  end
  resources :compliances do
    member do
      get 'launch', to: 'compliances#launch'
      get 'review', to: 'compliances#review'
    end
  end
  resources :goals do
    member do
      get 'launch', to: 'goals#launch'
      get 'review', to: 'goals#review'
    end
  end
  resources :announcements do
    member do
      get 'launch', to: 'announcements#launch'
      get 'review', to: 'announcements#review'
    end
  end
  get '/dashboard_new' => 'dashboard_new#index'
  get '/get_members' => 'dashboard_new#get_members'
  get 'feedbacks/index'
  get 'trackings/index'
  get 'users/index'
  get '/dashboard'=>"admin#index"
  get '/quality_improvements'=>"admin#quality_improvements"
  get '/quality_improvements/details'=>"admin#quality_improvement_details"
  get '/announcement/details'=>"admin#announcement_details"
  get '/announcements'=>"admin#announcements"
  get '/health'=>"admin#health"
  get '/health/details'=>"admin#health_details"
  get '/total_referrals'=>"admin#total_referrals"
  get '/referrals_used'=>"admin#referrals_used"
  get '/review_support'=>"admin#review_support"
  get '/approved_support'=>"admin#approved_support"
  get '/member_support'=>"admin#member_support"
  get '/support_service'=>"admin#support_service"
  get '/referral_providers'=>"admin#referral_providers"
  get '/demo_workflow'=>"admin#demo_workflow"
  get '/demo_announcement'=>"admin#demo_announcement"
  get '/demo_health'=>"admin#demo_health"
  get '/demo_workflow/listing'=>"admin#demo_workflow_listing"
  resources :members
  resources :members_imports, only: [:new, :create]
  resources :users, :only=>[:index]
  resources :trackings, :only=>[:index]
  resources :feedbacks, :only=>[:index]
  resources :user_actions, :only=>[:show]
  authenticate :user, lambda { |u| u.super_admin } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
  devise_for :users, controllers: {
    sessions: 'sessions'
  }
  devise_scope :user do
    get 'otp_verification', to: 'sessions#otp_verification', as: 'otp_verification'
    post 'verify_otp', to: 'sessions#verify_otp', as: 'verify_otp'
    get 'resend_otp' => "sessions#resend_otp", as: 'resend_otp'
  end

  # devise_for :users, controllers: {
  #     sessions: 'users/sessions'
  # }
  namespace :api do
    namespace :v1 do
      resources :allergies, :only=>[:index]
      resources :document_types,:only=>[:index]
      resources :payment_types,:only=>[:index]
      resources :specialities,:only=>[:index]
      resources :symptoms,:only=>[:index]
      resources :refers,:only=>[:index]
      resources :insurance_types,:only=>[:index]
      resources :visit_types,:only=>[:index]
      resources :states,:only=>[:index]
      mount_devise_token_auth_for 'User', at: 'auth'
      post 'auth/send_otp'=>"users#send_otp"
      post 'auth/verify_otp'=>"users#verify_otp"
      resources :users, :only=>[:update] do
        collection do
          get 'family_members' => 'users#family_members'
          put 'add_family_members' => 'users#add_or_update_family_members'
        end
      end
      resources :immunizations, :only=>[:index]
      resources :pet_service_providers, :only=>[:index]
      resources :trackings, :only=>[:create]
      resources :feedbacks, :only=>[:create]
      resources :payments, :only=>[:create]
      resources :user_actions, only: [:index ,:show, :update] do
        member do
          resources :user_action_steps, only: [:update]
        end
        collection do
          get 'action_plans' => 'user_actions#action_plans'
          get 'announcements' => 'user_actions#announcements'
          get 'feedbacks' => 'user_actions#feedbacks'
        end
      end
      resources :timely_recovery_goals, only: [:create]
      resources :medications, only: [:create, :update, :destroy]
      resources :vitals, only: [ :create, :destroy ]
      get 'dashboards/counters_summary' => 'dashboards#counters_summary'
      resources :support_needs, only: [:index, :create, :destroy]
      namespace :overseers do
        post 'login', to: 'overseer_auth#login'
        resources :support_needs
        get 'members_enrollment_status' => 'members#index'
        get 'medication_adherence_info' => 'medications#index'
        get 'member_compliance_status' => 'member_compliances#index'
        get 'timely_recovery_goals' => 'timely_recovery_goals#index'
        get 'quality_improvement_goals' => 'goals#index'
        get 'feedbacks' => 'member_feedbacks#index'
        get 'compliances' => 'compliances#index'
        get 'health_educations' => 'health_educations#index'
        get 'health_events' => 'health_events#index'
        get 'announcements' => 'announcements#index'
      end
    end
  end
  root "dashboard_new#index"
  post "custom_templates/get_category"=>"custom_templates#get_category", as: 'get_category'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
