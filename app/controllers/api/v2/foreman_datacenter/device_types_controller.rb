module Api
  module V2
    module ForemanDatacenter
      class DeviceTypesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceType

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::DeviceType)

        api :GET, "/foreman_datacenter/device_types/", N_("List all device_types")

        def index
          @device_types = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_types/:id/", N_("Show a device_type")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_type do
	  param :device_type, Hash, :required => true, :action_aware => true do
	    param :model, String, :required => true
	    param :manufacturer_id, :number, :desc => N_("Manufacturer ID")
	    param :u_height, :number, :desc => N_("U Height")
	    param :is_full_depth, :boolean, :desc => N_("is_full_depth")
	    param :is_pdu, :boolean, :desc => N_("is_pdu")
	    param :is_network_device, :boolean, :desc => N_("is_network_device")
	    param :subdevice_role, String, :desc => N_("subdevice_role")
	  end
	end

	api :POST, "/foreman_datacenter/device_types", N_("Create a device_type")
	param_group :device_type, :as => :create

	def create
	  @device_type = ::ForemanDatacenter::DeviceType.new(device_type_params)
	  process_response @device_type.save
	end

	api :PUT, "/foreman_datacenter/device_types/:id/", N_("Update a device_type")
	param :id, :identifier, :required => true
	param_group :device_type

	def update
	  process_response @device_type.update(device_type_params)
	end

	api :DELETE, "/foreman_datacenter/device_types/:id/", N_("Delete a device_type")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_type.destroy
	end

        def allowed_nested_id
          %w(console_port_template_id)
        end

      end
    end
  end
end
