module ForemanDatacenter
  class SitesController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Site

    before_action :find_resource, only: [:show, :edit, :update, :destroy, :move, :racks]

    def index
      @sites = resource_base_search_and_page
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
      unless params['object_only']
        @site.racks.each { |r| r.devices.each { |d| d.destroy } }
        @site.rack_groups.delete_all(:delete_all)
        @site.racks.delete_all(:delete_all)
      else
        @site.rack_groups.delete_all(:nullify)
        @site.racks.delete_all(:nullify)
      end

      if @site.destroy
        process_success success_redirect: sites_path
      else
        process_error object: @site
      end
    end

    def racks
      @rack_groups = @site.rack_groups.includes(racks: [devices: [:device_role]])
      @ungrouped_racks = @site.racks.where(rack_group_id: nil)#.includes(:device_role)
      process_error redirect: site_path(@site), error_msg: 'Current site haven\'t any Racks.' if (@rack_groups.empty? && @ungrouped_racks.empty?)
    end

    def move
      @sites = resource_base_search_and_page
      @rack_groups = @site.rack_groups
      @racks = @site.racks
      process_error object: @site, error_msg: 'Current site haven\'t any Racks/RackGroups.' if (@racks.empty? && @rack_groups.empty?)
    end

    def update_associated_objects
      begin
        @site = ForemanDatacenter::Site.find(request.env['HTTP_REFERER'].split('/')[-2])
        @rack_groups = @site.rack_groups
        @racks = @site.racks
        @racks.update_all(site_id: params[:site_id])
        @rack_groups.update_all(site_id: params[:site_id])
        process_success success_redirect: sites_path, success_msg: 'Associated objects successfully moved.'
      rescue => e
        process_error object: @site, error_msg: "#{e}"
      end
    end
  end
end
