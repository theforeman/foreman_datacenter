module Api
  module V2
    module ForemanDatacenter
      class RacksController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::Rack

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::Rack)

        api :GET, "/foreman_datacenter/racks/", N_("List all racks")

        def index
          @racks = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/racks/:id/", N_("Show a rack")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :rack do
	  param :rack, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :site_id, :number, :desc => N_("Site ID")
	    param :rack_group_id, :number, :desc => N_("RackGroup ID")
	    param :facility_id, :number, :desc => N_("Facility ID")
	    param :height, :number, :desc => N_("Facility ID")
	    param :comments, String, :desc => N_("Comments")
	  end
	end

	api :POST, "/foreman_datacenter/racks", N_("Create a rack")
	param_group :rack, :as => :create

	def create
	  @rack = ::ForemanDatacenter::Rack.new(rack_params)
	  process_response @rack.save
	end

	api :PUT, "/foreman_datacenter/racks/:id/", N_("Update a rack")
	param :id, :identifier, :required => true
	param_group :rack

	def update
	  process_response @rack.update(rack_params)
	end

	api :DELETE, "/foreman_datacenter/racks/:id/", N_("Delete a rack")
	param :id, :identifier, :required => true

	def destroy
	  process_response @rack.destroy
	end

      end
    end
  end
end
