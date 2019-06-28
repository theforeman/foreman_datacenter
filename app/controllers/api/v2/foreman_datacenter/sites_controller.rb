module Api
  module V2
    module ForemanDatacenter
      class SitesController < ForemanDatacenter::BaseController
        include ::ForemanDatacenter::Controller::Parameters::Site

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{show update destroy}

        api :GET, "/foreman_datacenter/sites/", N_("List all sites")
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::Site)

        # api!
        def index
          @sites = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/sites/:id/", N_("Show a site")
        param :id, :identifier, :required => true

        def show
        end

        def_param_group :site do
          param :site, Hash, :required => true, :action_aware => true do
            param :name, String, :required => true
            param :rack_ids, Array, :desc => N_("Rack IDs")
            param :rack_group_ids, Array, :desc => N_("RackGroup IDs")
          end
        end

        api :POST, "/foreman_datacemter/sites", N_("Create a site")
        param_group :site, :as => :create

        def create
          @site = ::ForemanDatacenter::Site.new(site_params)
          process_response @site.save
        end

        api :PUT, "/foreman_datacenter/sites/:id/", N_("Update a site")
        param :id, :identifier, :required => true
        param_group :site

        def update
          process_response @site.update(site_params)
        end

        api :DELETE, "/foreman_datacenter/sites/:id/", N_("Delete a site")
        param :id, :identifier, :required => true

        def destroy
          process_response @site.destroy
        end

      end
    end
  end
end
