Rails.application.routes.draw do
  # todo: remove later
  get 'new_action', to: 'foreman_datacenter/hosts#new_action'

  scope 'datacenter', module: :foreman_datacenter do
    resources :sites
    resources :racks do
      collection do
        get :rack_groups
      end
    end
    resources :rack_groups
  end
end
