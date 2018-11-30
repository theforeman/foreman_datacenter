module ForemanDatacenter
  class RacksController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Rack

    before_action :find_resource, only: [:show, :edit, :update, :destroy, :devices, :move]

    def index
      @racks = resource_base_search_and_page.includes(:site, :rack_group)
    end

    # action for async selecting rack_group in rack _form
    def rack_groups
      @rack_groups = ForemanDatacenter::RackGroup.where(site_id: params[:site_id]).all
      render partial: 'rack_groups'
    end

    def show
      @rack = resource_base.includes(devices: [:device_role]).find(params[:id])
    end

    def new
      @rack = ForemanDatacenter::Rack.new
    end

    def edit
    end

    def create
      @rack = ForemanDatacenter::Rack.new(rack_params)

      if @rack.save
        process_success object: @rack
      else
        process_error object: @rack
      end
    end

    def update
      if @rack.update(rack_params)
        process_success object: @rack
      else
        process_error object: @rack
      end
    end

    def destroy
      unless params['object_only']
        @rack.devices.each { |d| d.destroy }
      else
        @rack.devices.delete_all(:nullify)
      end

      if @rack.destroy
        process_success success_redirect: racks_path
      else
        process_error object: @rack
      end
    end

    def move
      @racks = resource_base_search_and_page
      @devices = @rack.devices
      process_error object: @rack, error_msg: 'Current Rack haven\'t any Devices.' if @devices.empty?
    end

    def update_associated_objects
      begin
        @rack = ForemanDatacenter::Rack.find(request.env['HTTP_REFERER'].split('/')[-2])
        @devices = @rack.devices
        @devices.update_all(rack_id: params[:rack_id])
        process_success success_redirect: racks_path, success_msg: 'Associated objects successfully moved.'
      rescue => e
        process_error object: @rack, error_msg: "#{e}"
      end
    end
  end
end
