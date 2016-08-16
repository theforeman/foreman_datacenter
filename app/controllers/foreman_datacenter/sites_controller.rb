module ForemanDatacenter
  class SitesController < ApplicationController
    before_action :set_site, only: [:show, :edit, :update, :destroy]

    def index
      @sites = Site.all
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
