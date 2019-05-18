module Api
  module V2
    module ForemanDatacenter
      class RackGroupsController < ForemanDatacenter::BaseController
        include ::ForemanDatacenter::Controller::Parameters::RackGroup

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/rack_groups/", N_("List all rack groups")

        def index
          @rack_groups = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/rack_groups/:id/", N_("Show a rack group")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :rack_group do
	  param :rack_group, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
            param :site_id, String, :desc => N_("Site ID")
	  end
	end

	api :POST, "/foreman_datacenter/rack_groups", N_("Create a rack group")
	param_group :rack_group, :as => :create

	def create
	  @rack_group = ::ForemanDatacenter::RackGroup.new(rack_group_params)
	  process_response @rack_group.save
	end

	api :PUT, "/foreman_datacenter/rack_groups/:id/", N_("Update a rack group")
	param :id, :identifier, :required => true
	param_group :rack_group

	def update
	  process_response @rack_group.update(rack_group_params)
	end

	api :DELETE, "/foreman_datacenter/rack_groups/:id/", N_("Delete a rack group")
	param :id, :identifier, :required => true

	def destroy
	  process_response @rack_group.destroy
	end

        private

        def allowed_nested_id
          %w(site_id)
        end

      end
    end
  end
end
