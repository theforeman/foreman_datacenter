module Api
  module V2
    module ForemanDatacenter
      class DeviceModulesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceModule

        before_action :find_resource, :only => %w{show update destroy}
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/device_modules/", N_("List all DeviceModules")

        def index
          @device_modules = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_moudles/:id/", N_("Show a DeviceModule")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_module do
	  param :device_module, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :required => true
	    param :part_id, String, :required => true
	    param :serial, String, :required => true
	  end
	end

	api :POST, "/foreman_datacenter/devices/:device_id/device_modules", N_("Create a device_module")
	param_group :device_module, :as => :create

	def create
	  @device_module = ::ForemanDatacenter::DeviceModule.new(device_module_params)
	  process_response @device_module.save
	end

	api :PUT, "/foreman_datacenter/devices/:device_id/device_modules/:id/", N_("Update a device_module")
	param :id, :identifier, :required => true
	param_group :device_module

	def update
	  process_response @device_module.update(device_module_params)
	end

	api :DELETE, "/foreman_datacenter/devices/:device_id/device_modules/:id/", N_("Delete a device_module")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_module.destroy
	end

      end
    end
  end
end
