module ForemanDatacenter
  class RacksController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Rack

    before_action :find_resource, only: [:show, :edit, :update, :destroy, :devices]

    def index
      @racks = resource_base_search_and_page.includes(:site, :rack_group, :devices)
    end

    # action for async selecting rack_group in rack _form
    def rack_groups
      @rack_groups = ForemanDatacenter::RackGroup.where(site_id: params[:site_id]).all
      render partial: 'rack_groups'
    end

    def show
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
      if @rack.destroy
        process_success success_redirect: racks_path
      else
        process_error object: @rack
      end
    end
  end
end
