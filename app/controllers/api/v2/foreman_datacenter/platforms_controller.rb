module Api
  module V2
    module ForemanDatacenter
      class PlatformsController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::Platform

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::Platform)

        api :GET, "/foreman_datacenter/platforms/", N_("List all platforms")

        def index
          @platforms = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/platforms/:id/", N_("Show a platform")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :platform do
	  param :platform, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :rpc_client, :number, :desc => N_("RPC Client")
	  end
	end

	api :POST, "/foreman_datacenter/platforms", N_("Create a platform")
	param_group :platform, :as => :create

	def create
	  @platform = ::ForemanDatacenter::Platform.new(platform_params)
	  process_response @platform.save
	end

	api :PUT, "/foreman_datacenter/platforms/:id/", N_("Update a platform")
	param :id, :identifier, :required => true
	param_group :platform

	def update
	  process_response @platform.update(platform_params)
	end

	api :DELETE, "/foreman_datacenter/platforms/:id/", N_("Delete a platform")
	param :id, :identifier, :required => true

	def destroy
	  process_response @platform.destroy
	end

      end
    end
  end
end
