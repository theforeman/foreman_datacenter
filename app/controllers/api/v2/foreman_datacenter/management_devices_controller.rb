module Api
  module V2
    module ForemanDatacenter
      class ManagementDevicesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::ManagementDevice

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/management_devices/", N_("List all ManagementDevices")

        def index
          @management_devices = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/management_devices/:id/", N_("Show a ManagementDevice")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :management_device do
	  param :management_device, Hash, :required => true, :action_aware => true do
	    param :device_id, :number, :required => true
	    param :console_url, String, :required => true
	    param :login, String, :required => true
	    param :password, String, :required => true
	  end
	end

	api :POST, "/foreman_datacenter/management_devices", N_("Create a management_device")
	param_group :management_device, :as => :create

	def create
	  @management_device = ::ForemanDatacenter::ManagementDevice.new(management_device_params)#.merge(device_id: params[]))
	  @management_device.save
	end

	api :PUT, "/foreman_datacenter/management_devices/:id/", N_("Update a management_device")
	param :id, :identifier, :required => true
	param_group :management_device

	def update
	  process_response @management_device.update(management_device_params)
	end

	api :DELETE, "/foreman_datacenter/management_devices/:id/", N_("Delete a management_device")
	param :id, :identifier, :required => true

	def destroy
	  process_response @management_device.destroy
	end

      end
    end
  end
end
