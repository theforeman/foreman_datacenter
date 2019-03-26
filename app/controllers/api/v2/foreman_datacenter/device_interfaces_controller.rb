module Api
  module V2
    module ForemanDatacenter
      class DeviceInterfacesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceInterface

        before_action :find_resource, :only => %w{show update destroy}
        before_action :find_optional_nested_object
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::DeviceInterface)
        
        api :GET, "/foreman_datacenter/device_interfaces/", N_("List all DeviceInterfaces")
        
        def index
          @device_interfaces = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_interfaces/:id/", N_("Show a DeviceBayTemplate")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_interface do
	  param :device_interface, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :desc => N_("Device ID")
	    param :form_factor, String, :desc => N_("Form Factor")
	    param :mac_address, String, :desc => N_("MAC address")
	    param :mgmn_only, :boolean, :desc => N_("Management only")
	    param :description, String, :desc => N_("Description")
	    param :ip_address, String, :desc => N_("IP address")
	  end
	end

	api :POST, "/foreman_datacenter/device_interfaces", N_("Create a DeviceInterface")
	param_group :device_interface, :as => :create

	def create
	  @device_interface = ::ForemanDatacenter::DeviceInterface.new(device_interface_params)
	  process_response @device_interface.save
	end

	api :PUT, "/foreman_datacenter/device_interfaces/:id/", N_("Update a DeviceInterface")
	param :id, :identifier, :required => true
	param_group :device_interface

	def update
	  process_response @device_interface.update(device_interface_params)
	end

	api :DELETE, "/foreman_datacenter/device_interfaces/:id/", N_("Delete a DeviceInterface")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_interface.destroy
	end

      end
    end
  end
end
