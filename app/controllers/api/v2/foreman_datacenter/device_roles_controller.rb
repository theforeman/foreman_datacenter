module Api
  module V2
    module ForemanDatacenter
      class DeviceRolesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceRole

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::DeviceRole)

        api :GET, "/foreman_datacenter/device_roles/", N_("List all device_roles")

        def index
          @device_roles = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_roles/:id/", N_("Show a device_role")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_role do
	  param :device_role, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :color, String, :required => true
	  end
	end

	api :POST, "/foreman_datacenter/device_roles", N_("Create a device_role")
	param_group :device_role, :as => :create

	def create
	  @device_role = ::ForemanDatacenter::DeviceRole.new(device_role_params)
	  process_response @device_role.save
	end

	api :PUT, "/foreman_datacenter/device_roles/:id/", N_("Update a device_role")
	param :id, :identifier, :required => true
	param_group :device_role

	def update
	  process_response @device_role.update(device_role_params)
	end

	api :DELETE, "/foreman_datacenter/device_roles/:id/", N_("Delete a device_role")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_role.destroy
	end

      end
    end
  end
end
