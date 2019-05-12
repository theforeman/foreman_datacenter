module Api
  module V2
    module ForemanDatacenter
      class DeviceBaysController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceBay

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy populate depopulate}
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::ConsolePortTemplate)
        
        api :GET, "/foreman_datacenter/device_bays/", N_("List all DeviceBays")
        
        def index
          @device_bays = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_bays/:id/", N_("Show a DeviceBay")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_bay do
	  param :device_bay, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :desc => N_("Device ID")
	  end
	end

	api :POST, "/foreman_datacenter/device_bays", N_("Create a DeviceBay")
	param_group :device_bay, :as => :create

	def create
	  @device_bay = ::ForemanDatacenter::DeviceBay.new(device_bay_params)
	  process_response @device_bay.save
	end

	api :PUT, "/foreman_datacenter/device_bays/:id/", N_("Update a DeviceBay")
	param :id, :identifier, :required => true
	param_group :device_bay

	def update
	  process_response @device_bay.update(device_bay_params)
	end

	api :DELETE, "/foreman_datacenter/device_bays/:id/", N_("Delete a DeviceBay")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_bay.destroy
	end

        api :PATCH, "/foreman_datacenter/device_bays/:id/populate", N_("Populate")
        param :id, :identifier, :required => true
        param_group :device_bay
        param :installed_device_id, :number, :desc => N_("Installed Device ID")

        def populate
          device_id = params[:installed_device_id]
          process_response @device_bay.update(installed_device_id: device_id)
        end

        api :DELETE, "/foreman_datacenter/device_bays/:id/depopulate", N_("Depopulate")
        param :id, :identifier, :required => true
        param_group :device_bay

        def depopulate
          process_response @device_bay.update(installed_device_id: nil)
        end

      end
    end
  end
end
