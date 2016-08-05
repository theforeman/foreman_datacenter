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
    resources :platforms
    resources :device_roles
    resources :manufacturers
    resources :device_types do
      resources :interface_templates, only: [:new, :create, :destroy],
                path: 'interfaces'
      resources :console_port_templates, only: [:new, :create, :destroy],
                path: 'console_ports'
      resources :power_port_templates, only: [:new, :create, :destroy],
                path: 'power_ports'
      resources :console_server_port_templates, only: [:new, :create, :destroy],
                path: 'console_server_ports'
      resources :power_outlet_templates, only: [:new, :create, :destroy],
                path: 'power_outlets'
      resources :device_bay_templates, only: [:new, :create, :destroy],
                path: 'device_bays'
    end
  end
end
