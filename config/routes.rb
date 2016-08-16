Foreman::Application.routes.draw do
  scope 'datacenter', module: :foreman_datacenter do
    resources :sites
    resources :racks do
      get :rack_groups, on: :collection
    end
    resources :rack_groups
    resources :platforms
    resources :device_roles
    resources :manufacturers
    resources :device_types do
      resources :interface_templates, only: [:new, :create, :destroy],
                path: 'interfaces' do
        get :new_management, on: :collection
      end
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
    resources :devices do
      collection do
        get :device_types, :racks, :for_rack
      end
      member do
        get :inventory
      end
      resources :device_bays, except: [:show, :index], shallow: true do
        member do
          get :populate_new
          patch :populate
          delete :depopulate
        end
      end
      resources :device_interfaces, except: [:show, :index], shallow: true do
        get :new_management, on: :collection
        resources :device_interface_connections, except: [:show, :edit, :update, :index],
                  shallow: true do
          member do
            patch :planned, :connected
          end
        end
      end
      resources :console_server_ports, except: [:show, :index], shallow: true do
        member do
          get :new_connection
          patch :connect, :disconnect
        end
      end
      resources :console_ports, except: [:show, :index], shallow: true do
        member do
          get :new_connection
          patch :connect, :disconnect, :connected, :planned
        end
      end
      resources :power_outlets, except: [:show, :index], shallow: true do
        member do
          get :new_connection
          patch :connect, :disconnect
        end
      end
      resources :power_ports, except: [:show, :index], shallow: true do
        member do
          get :new_connection
          patch :connected, :planned, :connect, :disconnect
        end
      end
      resources :device_modules, except: [:show, :index], shallow: true
    end
    resources :device_interface_connections, only: [:index], path: 'connections' do
      get :interfaces, on: :collection
    end
    resources :console_ports, only: [:index] do
      get :for_device, on: :collection
    end
    resources :power_ports, only: [:index] do
      get :for_device, on: :collection
    end
    resources :console_server_ports, only: [] do
      get :for_device, on: :collection
    end
    resources :power_outlets, only: [] do
      get :for_device, on: :collection
    end
  end
end
