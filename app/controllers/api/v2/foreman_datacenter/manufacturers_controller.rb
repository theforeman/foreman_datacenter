module Api
  module V2
    module ForemanDatacenter
      class ManufacturersController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::Manufacturer

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/manufacturers/", N_("List all manufacturers")

        def index
          @manufacturers = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/manufacturers/:id/", N_("Show a manufacturer")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :manufacturer do
	  param :manufacturer, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	  end
	end

	api :POST, "/foreman_datacenter/manufacturers", N_("Create a manufacturer")
	param_group :manufacturer, :as => :create

	def create
	  @manufacturer = ::ForemanDatacenter::Manufacturer.new(manufacturer_params)
	  process_response @manufacturer.save
	end

	api :PUT, "/foreman_datacenter/manufacturers/:id/", N_("Update a manufacturer")
	param :id, :identifier, :required => true
	param_group :manufacturer

	def update
	  process_response @manufacturer.update(manufacturer_params)
	end

	api :DELETE, "/foreman_datacenter/manufacturers/:id/", N_("Delete a manufacturer")
	param :id, :identifier, :required => true

	def destroy
	  process_response @manufacturer.destroy
	end

      end
    end
  end
end
