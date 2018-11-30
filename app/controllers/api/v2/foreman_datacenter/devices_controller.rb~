module Api
  module V2
    module ForemanDatacenter
      class DevicesController < ForemanDatacenter::BaseController
        include ::ForemanDatacenter::Controller::Parameters::Device

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy destroy_interfaces sync_interfaces_with_host}

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::Device)

        api :GET, "/foreman_datacenter/devices/", N_("List all Devices")

        def index
          @devices = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/devices/:id/", N_("Show a Device")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device do
	  param :device, Hash, :required => true, :action_aware => true do
            param :device_type_id, :number, :desc => N_("DeviceType ID")
            param :device_role_id, :number, :desc => N_("DeviceRole ID")
            param :platform_id, :number, :desc => N_("Platform ID")
	    param :name, String, :required => true
	    param :serial, String, :required => true
            param :rack_id, :number, :desc => N_("Rack ID")
	    param :position, :number, :required => true
	    param :face, :number, :required => true
	    param :status, :number, :required => true
	    param :primary_ip4, String, :required => true
	    param :primary_ip6, String, :required => true
	    param :host_id, :number, :required => true
	    param :side, :number, :required => true
	    param :size, :number, :required => true
	    param :organization_id, :number, :required => true
	    param :location_id, :number, :required => true
	  end
	end

	api :POST, "/foreman_datacenter/devices", N_("Create a rack group")
	param_group :device, :as => :create

	def create
	  @device = ::ForemanDatacenter::Device.new(device_params.merge(hosy_id: params[:host_id]))
	  process_response @device.save
	end

	api :PUT, "/foreman_datacenter/devices/:id/", N_("Update a rack group")
	param :id, :identifier, :required => true
	param_group :device

	def update
	  process_response @device.update(device_params)
	end

	api :DELETE, "/foreman_datacenter/devices/:id/", N_("Delete a rack group")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device.destroy
	end

	api :DELETE, "/foreman_datacenter/devices/:id/destroy_interfaces", N_("Destroy interfaces")
	param :id, :identifier, :required => true

        def destroy_interfaces
          @device.non_management_interfaces.
            where(id: params[:interfaces]).
            destroy_all
        end
    
	api :GET, "/foreman_datacenter/devices/:id/sync_interfaces_with_host", N_("Sync interfaces with host")
	param :id, :identifier, :required => true

        def sync_interfaces_with_host
          @device.sync_interfaces_with_host
        end
      end
    end
  end
end
