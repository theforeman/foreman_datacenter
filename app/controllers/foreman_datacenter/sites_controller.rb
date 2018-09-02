module ForemanDatacenter
  class SitesController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch

    before_action :set_site, only: [:show, :edit, :update, :destroy]

    def index
      begin
        search = resource_base.search_for(params[:search], :order => params[:order])
      rescue => e
        error e.to_s
        search = resource_base.search_for ''
      end
      # @sites = search.includes(:device_role, :device_type, :site, :rack).
      @sites = search.paginate(:page => params[:page], :per_page => params[:per_page])
    end

    def show
    end

    def new
      @site = Site.new
    end

    def edit
    end

    def create
      @site = Site.new(site_params)
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
        process_success object: @site
      else
        process_error object: @site
      end
    end

    private

    def set_site
      @site = Site.find(params[:id])
    end

    def site_params
      params[:site].
        permit(:name, :facility, :asn, :physical_address, :shipping_address, :comments)
    end
  end
end
