require 'deface'

module ForemanDatacenter
  class Engine < ::Rails::Engine
    engine_name 'foreman_datacenter'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_datacenter.load_app_instance_data' do |app|
      ForemanDatacenter::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_datacenter.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_datacenter do
        requires_foreman '>= 1.12'

        security_block :datacenter do
	  # Hosts
          permission :import_to_device, {
                      :'hosts' => [:import_to_device]},
                      :resource_type => "ForemanDatacenter::HostExtensions"
          # Comments
          permission :create_comments, {
                     :'foreman_datacenter/comments' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::Comments"
          permission :edit_comments, {
                     :'foreman_datacenter/comments' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::Comments"
          permission :destroy_comments, {
                     :'foreman_datacenter/comments' => [:destroy]},
                     :resource_type => "ForemanDatacenter::Comments"
          # ConsolePortTemplates /datacenter/device_types/:id/console_ports/...
          permission :create_console_port_templates, {
                     :'foreman_datacenter/console_port_templates' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::ConsolePortTemplates"
          permission :destroy_console_port_templates, {
                     :'foreman_datacenter/console_port_templates' => [:destroy]},
                     :resource_type => "ForemanDatacenter::ConsolePortTemplates"
          # ConsolePorts
          permission :view_console_ports, {
                     :'foreman_datacenter/console_ports' => [:index]},
                     :resource_type => "ForemanDatacenter::ConsolePort"
          permission :create_console_ports, {
                     :'foreman_datacenter/console_ports' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::ConsolePort"
          permission :edit_console_ports, {
                     :'foreman_datacenter/console_ports' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::ConsolePort"
          permission :destroy_console_ports, {
                     :'foreman_datacenter/console_ports' => [:destroy]},
                     :resource_type => "ForemanDatacenter::ConsolePort"
          # ConsoleServerPortTemplates
          permission :create_console_server_port_templates, {
                     :'foreman_datacenter/console_server_port_templates' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::ConsoleServerPortTemplate"
          permission :destroy_console_server_port_templates, {
                     :'foreman_datacenter/console_server_port_templates' => [:destroy]},
                     :resource_type => "ForemanDatacenter::ConsoleServerPortTemplate"
          # ConsoleServerPorts
          permission :create_console_server_ports, {
                     :'foreman_datacenter/console_server_ports' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::ConsoleServerPort"
          permission :edit_console_server_ports, {
                     :'foreman_datacenter/console_server_ports' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::ConsoleServerPort"
          permission :destroy_console_server_ports, {
                     :'foreman_datacenter/console_server_ports' => [:destroy]},
                     :resource_type => "ForemanDatacenter::ConsoleServerPort"
          permission :console_server_ports_connections, {
                     :'foreman_datacenter/console_server_ports' => [:new_connection, :connect, :disconnect, :for_device]},
                     :resource_type => "ForemanDatacenter::ConsoleServerPort"
          # DeviceBayTemplates /datacenter/device_types/:id/device_bays/...
          permission :create_device_bay_templates, {
                     :'foreman_datacenter/device_bay_templates' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceBayTemplate"
          permission :destroy_device_bay_templates, {
                     :'foreman_datacenter/device_bay_templates' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceBayTemplate"
          # DeviceBays
          permission :create_device_bays, {
                     :'foreman_datacenter/device_bays' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceBay"
          permission :edit_device_bays, {
                     :'foreman_datacenter/device_bays' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::DeviceBay"
          permission :destroy_device_bays, {
                     :'foreman_datacenter/device_bays' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceBay"
          permission :population, {
                     :'foreman_datacenter/device_bays' => [:populate_new, :populate, :depopulate]},
                     :resource_type => "ForemanDatacenter::DeviceBay"
          # DeviceInterfaceConnections
          permission :view_device_interface_connections, {
                     :'foreman_datacenter/device_interface_connections' => [:index]},
                     :resource_type => "ForemanDatacenter::DeviceInterfaceConnection"
          permission :create_device_interface_connections, {
                     :'foreman_datacenter/device_interface_connections' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceInterfaceConnection"
          permission :edit_device_interface_connections, {
                     :'foreman_datacenter/device_interface_connections' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceInterfaceConnection"
          permission :device_interface_connections_management, {
                     :'foreman_datacenter/device_interface_connections' => [:planned, :connected, :interfaces]},
                     :resource_type => "ForemanDatacenter::DeviceInterfaceConnection"
          # DeviceInterfaces
          permission :create_device_interfaces, {
                     :'foreman_datacenter/device_interfaces' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceInterface"
          permission :edit_device_interfaces, {
                     :'foreman_datacenter/device_interfaces' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::DeviceInterface"
          permission :destroy_device_interfaces, {
                     :'foreman_datacenter/device_interfaces' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceInterface"
          permission :device_interfaces_new_management, {
                     :'foreman_datacenter/device_interfaces' => [:new_management]},
                     :resource_type => "ForemanDatacenter::DeviceInterface"
          # DeviceModules
          permission :create_devices_modules, {
                     :'foreman_datacenter/device_modules' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceModule"
          permission :edit_device_modules, {
                     :'foreman_datacenter/device_modules' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::DeviceModule"
          permission :destroy_device_modules, {
                     :'foreman_datacenter/device_modules' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceModule"
          # DeviceRoles
          permission :view_device_roles, {
                     :'foreman_datacenter/device_roles' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::DeviceRole"
          permission :create_devices_roles, {
                     :'foreman_datacenter/device_roles' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceRole"
          permission :edit_device_roles, {
                     :'foreman_datacenter/device_roles' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::DeviceRole"
          permission :destroy_device_roles, {
                     :'foreman_datacenter/device_roles' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceRole"
          # DeviceTypes
          permission :view_device_types, {
                     :'foreman_datacenter/device_types' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::DeviceType"
          permission :create_devices_types, {
                     :'foreman_datacenter/device_types' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::DeviceType"
          permission :edit_device_types, {
                     :'foreman_datacenter/device_types' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::DeviceType"
          permission :destroy_device_types, {
                     :'foreman_datacenter/device_types' => [:destroy]},
                     :resource_type => "ForemanDatacenter::DeviceType"
          # Devices
          permission :view_devices, {
                     :'foreman_datacenter/devices' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :create_devices, {
                     :'foreman_datacenter/devices' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :edit_devices, {
                     :'foreman_datacenter/devices' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :destroy_devices, {
                     :'foreman_datacenter/devices' => [:destroy]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :inventory, {
                     :'foreman_datacenter/devices' => [:inventory]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :device_types, {
                     :'foreman_datacenter/devices' => [:device_types, :device_type_size]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :device_racks, {
                     :'foreman_datacenter/devices' => [:racks, :for_rack]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :destroy_interfaces, {
                     :'foreman_datacenter/devices' => [:destroy_interfaces]},
                     :resource_type => "ForemanDatacenter::Device"
          permission :qr_code, {
                     :'foreman_datacenter/devices' => [:qr_code]},
                     :resource_type => "ForemanDatacenter::Device"
          # InterfaceTemplates /datacenter/device_types/:id/interfaces/...
          permission :create_interface_templates, {
                     :'foreman_datacenter/interface_templates' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::InterfaceTemplate"
          permission :destroy_interface_templates, {
                     :'foreman_datacenter/interface_templates' => [:destroy]},
                     :resource_type => "ForemanDatacenter::InterfaceTemplate"
          permission :new_management, {
                     :'foreman_datacenter/interface_templates' => [:new_management]},
                     :resource_type => "ForemanDatacenter::InterfaceTemplate"
          # ManagementDevices
          permission :create_management_devices, {
                     :'foreman_datacenter/management_devices' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::ManagementDevice"
          permission :edit_management_devices, {
                     :'foreman_datacenter/management_devices' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::ManagementDevice"
          permission :destroy_management_devices, {
                     :'foreman_datacenter/management_devices' => [:destroy]},
                     :resource_type => "ForemanDatacenter::ManagementDevice"
          # Manufacturers
          permission :view_manufacturers, {
                     :'foreman_datacenter/manufacturers' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::Manufacturer"
          permission :create_manufacturers, {
                     :'foreman_datacenter/manufacturers' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::Manufacturer"
          permission :edit_manufacturers, {
                     :'foreman_datacenter/manufacturers' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::Manufacturer"
          permission :destroy_manufacturers, {
                     :'foreman_datacenter/manufacturers' => [:destroy]},
                     :resource_type => "ForemanDatacenter::Manufacturer"
          # Platforms
          permission :view_platforms, {
                     :'foreman_datacenter/platforms' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::Platform"
          permission :create_platforms, {
                     :'foreman_datacenter/platforms' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::Platform"
          permission :edit_platforms, {
                     :'foreman_datacenter/platforms' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::Platform"
          permission :destroy_platforms, {
                     :'foreman_datacenter/platforms' => [:destroy]},
                     :resource_type => "ForemanDatacenter::Platform"
          # PowerOutletTemplates
          permission :create_power_outlet_templates, {
                     :'foreman_datacenter/power_outlet_templates' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::PowerOutletTemplate"
          permission :destroy_power_outlet_templates, {
                     :'foreman_datacenter/power_outlet_templates' => [:destroy]},
                     :resource_type => "ForemanDatacenter::PowerOutletTemplate"
          # PowerOutlets
          permission :create_power_outlets, {
                     :'foreman_datacenter/power_outlets' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::PowerOutlets"
          permission :edit_power_outlets, {
                     :'foreman_datacenter/power_outlets' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::PowerOutlets"
          permission :destroy_power_outlets, {
                     :'foreman_datacenter/power_outlets' => [:destroy]},
                     :resource_type => "ForemanDatacenter::PowerOutlets"
          permission :power_outlets_connections, {
                     :'foreman_datacenter/power_outlets' => [:new_connection, :connect, :disconnect, :for_device]},
                     :resource_type => "ForemanDatacenter::PowerOutlets"
          # PowerPortTemplates /datacenter/device_types/:id/power_ports/...
          permission :create_power_port_templates, {
                     :'foreman_datacenter/power_port_templates' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::PowerPortTemplates"
          permission :destroy_power_port_templates, {
                     :'foreman_datacenter/power_port_templates' => [:destroy]},
                     :resource_type => "ForemanDatacenter::PowerPortTemplates"
          # PowerPorts
          permission :view_power_ports, {
                     :'foreman_datacenter/power_ports' => [:index]},
                     :resource_type => "ForemanDatacenter::PowerPort"
          permission :create_power_ports, {
                     :'foreman_datacenter/power_ports' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::PowerPort"
          permission :edit_power_ports, {
                     :'foreman_datacenter/power_ports' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::PowerPort"
          permission :destroy_power_ports, {
                     :'foreman_datacenter/power_ports' => [:destroy]},
                     :resource_type => "ForemanDatacenter::PowerPort"
          permission :power_ports_connections_management, {
                     :'foreman_datacenter/device_interface_connections' => [:planned, :connected, :for_device, :new_connection, :connect, :disconnect]},
                     :resource_type => "ForemanDatacenter::PowerPort"
          # RackGroups
          permission :view_rack_groups, {
                     :'foreman_datacenter/rack_groups' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::RackGroup"
          permission :create_rack_groups, {
                     :'foreman_datacenter/rack_groups' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::RackGroup"
          permission :edit_rack_groups, {
                     :'foreman_datacenter/rack_groups' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::RackGroup"
          permission :destroy_rack_groups, {
                     :'foreman_datacenter/rack_groups' => [:destroy]},
                     :resource_type => "ForemanDatacenter::RackGroup"
          # Racks
          permission :view_racks, {
                     :'foreman_datacenter/racks' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::Rack"
          permission :create_racks, {
                     :'foreman_datacenter/racks' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::Rack"
          permission :edit_racks, {
                     :'foreman_datacenter/racks' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::Rack"
          permission :destroy_racks, {
                     :'foreman_datacenter/racks' => [:destroy]},
                     :resource_type => "ForemanDatacenter::Rack"
          permission :racks_groups, {
                     :'foreman_datacenter/racks' => [:rack_groups]},
                     :resource_type => "ForemanDatacenter::Rack"
          # Sites
          permission :view_sites, {
                     :'foreman_datacenter/sites' => [:show, :index]},
                     :resource_type => "ForemanDatacenter::Site"
          permission :create_sites, {
                     :'foreman_datacenter/sites' => [:new, :create]},
                     :resource_type => "ForemanDatacenter::Site"
          permission :edit_sites, {
                     :'foreman_datacenter/sites' => [:edit, :update]},
                     :resource_type => "ForemanDatacenter::Site"
          permission :destroy_sites, {
                     :'foreman_datacenter/sites' => [:destroy]},
                     :resource_type => "ForemanDatacenter::Site"
        end

        MANAGER = [
          :import_to_device,
          :create_comments,
          :edit_comments,
          :destroy_comments,
          :create_console_port_templates,
          :destroy_console_port_templates,
          :view_console_ports,
          :create_console_ports,
          :edit_console_ports,
          :destroy_console_ports,
          :create_console_server_port_templates,
          :destroy_console_server_port_templates,
          :create_console_server_ports,
          :edit_console_server_ports,
          :destroy_console_server_ports,
          :console_server_ports_connections,
          :create_device_bay_templates,
          :destroy_device_bay_templates,
          :create_device_bays,
          :edit_device_bays,
          :destroy_device_bays,
          :population,
          :view_device_interface_connections,
          :create_device_interface_connections,
          :edit_device_interface_connections,
          :device_interface_connections_management,
          :create_device_interfaces,
          :edit_device_interfaces,
          :destroy_device_interfaces,
          :device_interfaces_new_management,
          :create_devices_modules,
          :edit_device_modules,
          :destroy_device_modules,
          :view_device_roles,
          :create_devices_roles,
          :edit_device_roles,
          :destroy_device_roles,
          :view_device_types,
          :create_devices_types,
          :edit_device_types,
          :destroy_device_types,
          :view_devices,
          :create_devices,
          :edit_devices,
          :destroy_devices,
          :inventory,
          :device_types,
          :device_racks,
          :destroy_interfaces,
          :qr_code,
          :create_interface_templates,
          :destroy_interface_templates,
          :new_management,
          :create_management_devices,
          :edit_management_devices,
          :destroy_management_devices,
          :view_manufacturers,
          :create_manufacturers,
          :edit_manufacturers,
          :destroy_manufacturers,
          :view_platforms,
          :create_platforms,
          :edit_platforms,
          :destroy_platforms,
          :create_power_outlet_templates,
          :destroy_power_outlet_templates,
          :create_power_outlets,
          :edit_power_outlets,
          :destroy_power_outlets,
          :power_outlets_connections,
          :create_power_port_templates,
          :destroy_power_port_templates,
          :view_power_ports,
          :create_power_ports,
          :edit_power_ports,
          :destroy_power_ports,
          :power_ports_connections_management,
          :view_rack_groups,
          :create_rack_groups,
          :edit_rack_groups,
          :destroy_rack_groups,
          :view_racks,
          :create_racks,
          :edit_racks,
          :destroy_racks,
          :racks_groups,
          :view_sites,
          :create_sites,
          :edit_sites,
          :destroy_sites,
        ]
        role "Datacenter Manager", MANAGER
        add_all_permissions_to_default_roles

        sub_menu :top_menu, :datacenter, :after=> :infrastructure_menu, :icon => 'pficon pficon-enterprise' do
          menu :top_menu, :sites, :url_hash => { controller: :'foreman_datacenter/sites', action: :index }
          divider :top_menu, :parent => :datacenter, :after => :sites, :caption => 'Racks'
          menu :top_menu, :racks, :url_hash => { controller: :'foreman_datacenter/racks', action: :index }
          menu :top_menu, :rack_groups, :url_hash => { controller: :'foreman_datacenter/rack_groups', action: :index }
          divider :top_menu, :parent => :datacenter, :after => :rack_groups, :caption => 'Devices'
          menu :top_menu, :devices, :url_hash => { controller: :'foreman_datacenter/devices', action: :index }
          menu :top_menu, :device_types, :url_hash => { controller: :'foreman_datacenter/device_types', action: :index }
          menu :top_menu, :device_roles, :url_hash => { controller: :'foreman_datacenter/device_roles', action: :index }
          menu :top_menu, :manufacturers, :url_hash => { controller: :'foreman_datacenter/manufacturers', action: :index }
          menu :top_menu, :platforms, :url_hash => { controller: :'foreman_datacenter/platforms', action: :index }
          divider :top_menu, :parent => :datacenter, :after => :interfaces, :caption => 'Connections'
          menu :top_menu, :console_connections, :url_hash => { controller: :'foreman_datacenter/console_ports', action: :index }
          menu :top_menu, :power_connections, :url_hash => { controller: :'foreman_datacenter/power_ports', action: :index }
          menu :top_menu, :interface_connections, :url_hash => { controller: :'foreman_datacenter/device_interface_connections', action: :index }
        end
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_datacenter.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_datacenter.configure_assets', group: :assets do
      SETTINGS[:foreman_datacenter] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanDatacenter::HostExtensions)
        HostsController.send(:include, ForemanDatacenter::HostsControllerExtensions)
      rescue => e
        Rails.logger.warn "ForemanDatacenter: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanDatacenter::Engine.load_seed
      end
    end

    initializer 'foreman_datacenter.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_datacenter'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
