module Api
  module V2
    module ForemanDatacenter
      class DevicesController < ForemanDatacenter::BaseController
        include ::ForemanDatacenter::Controller::Parameters::Device

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

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

	# def_param_group :device do
	#   param :device, Hash, :required => true, :action_aware => true do
	#     param :name, String, :required => true
        #     param :site_id, String, :desc => N_("Site ID")
	#   end
	# end

	# api :POST, "/foreman_datacenter/devices", N_("Create a rack group")
	# param_group :device, :as => :create

	# def create
	#   @device = ::ForemanDatacenter::Device.new(device_params)
	#   process_response @device.save
	# end

	# api :PUT, "/foreman_datacenter/devices/:id/", N_("Update a rack group")
	# param :id, :identifier, :required => true
	# param_group :device

	# def update
	#   process_response @device.update(device_params)
	# end

	# api :DELETE, "/foreman_datacenter/devices/:id/", N_("Delete a rack group")
	# param :id, :identifier, :required => true

	# def destroy
	#   process_response @device.destroy
	# end

        # private

        # def allowed_nested_id
        #   %w(site_id)
        # end

      end
    end
  end
end
