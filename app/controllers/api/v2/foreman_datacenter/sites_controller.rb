module Api
  module V2
    module ForemanDatacenter
      class SitesController < V2::BaseController
        include ScopesPerAction

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::Site)

        api :GET, "/sites/", N_("List all sites")

        def index
          # abort ::ForemanDatacenter::Site.inspect
          # @sites = resource_scope_for_index
          @sites = action_scope_for(:index, resource_scope_for_index)
          # ::ForemanDatacenter::Site.unscoped { @sites = resource_scope_for_index }
        end

      end
    end
  end
end
