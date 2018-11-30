module ForemanDatacenter
  class SitesController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Site

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @sites = resource_base_search_and_page
      # a = Site.includes(:racks).group(['sites.id', 'racks.site_id']).order('COUNT(racks.id) DESC').references(:racks)
      # abort a.inspect
    end

    def new
      @site = ForemanDatacenter::Site.new
    end

    def edit
    end

    def create
      @site = ForemanDatacenter::Site.new(site_params)
      if @site.save
        process_success object: @site
      else
        process_error object: @site
      end
    end

    def update
      if @site.update(site_params)
        process_success object: @site
      else
        process_error object: @site
      end
    end

    def destroy
      if @site.destroy
        process_success success_redirect: sites_path
      else
        process_error object: @site
      end
    end
  end
end
