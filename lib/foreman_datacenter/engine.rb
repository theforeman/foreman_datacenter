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
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_datacenter do
          permission :view_foreman_datacenter, :'foreman_datacenter/hosts' => [:new_action]
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanDatacenter', [:view_foreman_datacenter]

        sub_menu :top_menu, :datacenter, :after=> :infrastructure_menu do
          menu :top_menu, :sites, :url_hash => { controller: :'foreman_datacenter/sites', action: :index }
          divider :top_menu, :parent => :datacenter, :after => :sites, :caption => 'Racks'
          menu :top_menu, :racks, :url_hash => { controller: :'foreman_datacenter/racks', action: :index }
          menu :top_menu, :rack_groups, :url_hash => { controller: :'foreman_datacenter/rack_groups', action: :index }
          divider :top_menu, :parent => :datacenter, :after => :rack_groups, :caption => 'Devices'
          menu :top_menu, :devices, :url_hash => { controller: :'foreman_datacenter/hosts', action: :new_action }
          menu :top_menu, :device_types, :url_hash => { controller: :'foreman_datacenter/device_types', action: :index }
          menu :top_menu, :device_roles, :url_hash => { controller: :'foreman_datacenter/device_roles', action: :index }
          menu :top_menu, :manufacturers, :url_hash => { controller: :'foreman_datacenter/manufacturers', action: :index }
          menu :top_menu, :platforms, :url_hash => { controller: :'foreman_datacenter/platforms', action: :index }
          divider :top_menu, :parent => :datacenter, :after => :interfaces, :caption => 'Connections'
          menu :top_menu, :interface_connections, :url_hash => { controller: :'foreman_datacenter/hosts', action: :new_action }
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
        HostsHelper.send(:include, ForemanDatacenter::HostsHelperExtensions)
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
