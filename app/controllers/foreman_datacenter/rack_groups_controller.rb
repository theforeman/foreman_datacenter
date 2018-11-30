module ForemanDatacenter
  class RackGroupsController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::RackGroup

    before_action :find_resource, only: [:show, :edit, :update, :destroy, :move]

    def index
      @rack_groups = resource_base_search_and_page.includes(:site, :racks)
    end

    def show
    end

    def new
      @rack_group = ForemanDatacenter::RackGroup.new
    end

    def edit
    end

    def create
      @rack_group = ForemanDatacenter::RackGroup.new(rack_group_params)

      if @rack_group.save
        process_success object: @rack_group
      else
        process_error object: @rack_group
      end
    end

    def update
      if @rack_group.update(rack_group_params)
        process_success object: @rack_group
      else
        process_error object: @rack_group
      end
    end

    def destroy
      unless params['object_only']
        @rack_group.racks.each { |r| r.devices.each { |d| d.destroy } }
        @rack_group.racks.destroy_all
      else
        @rack_group.racks.delete_all(:nullify)
      end

      if @rack_group.destroy
        process_success success_redirect: "/datacenter/rack_groups"
      else
        process_error object: @rack_group
      end
    end

    def move
      @rack_groups = resource_base_search_and_page
      @racks = @rack_group.racks
      process_error object: @rack_group, error_msg: 'Current Rack Group haven\'t any Racks.' if @racks.empty?
    end

    def update_associated_objects
      begin
        @rack_group = ForemanDatacenter::RackGroup.find(request.env['HTTP_REFERER'].split('/')[-2])
        @racks = @rack_group.racks
        @racks.update_all(rack_group_id: params[:rack_group_id])
        process_success success_redirect: rack_groups_path, success_msg: 'Associated objects successfully moved.'
      rescue => e
        process_error object: @rack_group, error_msg: "#{e}"
      end
    end
  end
end
