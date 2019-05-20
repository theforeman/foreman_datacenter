Foreman::Application.routes.draw do

  # API
  namespace :api, :defaults => {:format => 'json'} do
    # new v2 routes that point to v2
    scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'}, :apiv => /v2/, :constraints => ApiConstraints.new(:version => 2, :default => true) do
      scope 'foreman_datacenter', module: :foreman_datacenter do
        resources :console_port_templates, :except => [:new, :edit]
        resources :console_server_port_templates, :except => [:new, :edit]
        resources :interface_templates, :except => [:new, :edit]
        resources :device_bay_templates, :except => [:new, :edit]
        resources :power_outlet_templates, :except => [:new, :edit]
        resources :power_port_templates, :except => [:new, :edit]
        resources :device_types, :except => [:new, :edit]
        resources :devices do
          member do
            delete :destroy_interfaces
            get :sync_interfaces_with_host
          end
        end
        resources :console_ports, :except => [:new, :edit] do
          member do
            patch :connect, :disconnect, :connected, :planned
          end
        end
        resources :console_server_ports, :except => [:new, :edit] do
          member do
            patch :connect, :disconnect
          end
        end
        resources :device_bays, :except => [:new, :edit] do
          member do
            patch :populate
            delete :depopulate
          end
        end
        resources :device_interfaces, :except => [:new, :edit] do
          resources :device_interface_connections, only: [:create]
        end

        resources :device_interface_connections, :except => [:new, :edit] do
          member do
            patch :planned, :connected
          end
        end
        resources :device_interface_connections, only: [:index], path: 'connections' do
          get :interfaces, on: :collection
        end

        resources :device_modules, :except => [:new, :edit]
        resources :management_devices, :except => [:new, :edit]

        resources :power_outlets, :except => [:new, :edit] do
         member do
           patch :connect, :disconnect
         end
        end
        resources :sites, except: [:new, :edit]
        resources :racks, :except => [:new, :edit]
        resources :rack_groups, :except => [:new, :edit]
        resources :manufacturers, :except => [:new, :edit]
        resources :platforms, :except => [:new, :edit]
        resources :device_roles, :except => [:new, :edit]
        resources :power_ports, :except => [:new, :edit] do
          member do
            patch :connect, :disconnect, :connected, :planned
          end
        end
      end
    end
  end

  # TODO: find a better way to do this
  get 'datacenter/import_to_device', to: 'hosts#import_to_device',
      as: 'import_to_device'

  get '/api/:controller/(:action(/*welcome))'
  # get '/datacenter/(:controller)/help', :action => 'welcome', :as => "help"

  scope 'datacenter', module: :foreman_datacenter do

    post :site_update_associated_objects, to: "sites#update_associated_objects"
    post :rack_group_update_associated_objects, to: "rack_groups#update_associated_objects"
    post :rack_update_associated_objects, to: "racks#update_associated_objects"
    resources :comments, only: [:edit, :update, :destroy, :new]
    resources :sites do
      member do
        get :move
        get :racks
      end
      collection do
        get 'auto_complete_search'
      end
    end
    resources :racks do
      member do
        get :move
        get :racks
      end
      collection do
        get 'auto_complete_search'
      end
      get :rack_groups, on: :collection
    end
    resources :rack_groups do
      member do
        get :move
      end
      collection do
        get 'auto_complete_search'
      end
      resources :comments, only: [:create]
    end
    resources :platforms do
      collection do
        get 'auto_complete_search'
      end
    end
    resources :device_roles do
      collection do
        get 'auto_complete_search'
      end
    end
    resources :manufacturers do
      collection do
        get 'auto_complete_search'
      end
    end
    resources :device_types do
      collection do
        get 'auto_complete_search'
      end
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
      resources :comments, only: [:create]
      collection do
        get :device_types, :racks, :for_rack, :device_type_size, :site_racks
        get :auto_complete_search
      end
      member do
        get :inventory
        delete :destroy_interfaces
        get :qr_code
        get :sync_interfaces_with_host
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
      resources :management_devices, only: [:new, :create, :edit, :update, :destroy],
                shallow: true
    end
    resources :device_interface_connections, only: [:index], path: 'connections' do
      collection do
        get 'auto_complete_search'
      end
      get :interfaces, on: :collection
    end
    resources :console_ports, only: [:index] do
      collection do
        get 'auto_complete_search'
      end
      get :for_device, on: :collection
    end
    resources :power_ports, only: [:index] do
      collection do
        get 'auto_complete_search'
      end
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

