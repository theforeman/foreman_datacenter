module ForemanDatacenter
  class RacksController < ApplicationController
    before_action :set_rack, only: [:show, :edit, :update, :destroy, :devices]

    def index
      @racks = ForemanDatacenter::Rack.
        includes(:site, :rack_group, :devices).
        order(:name).
        all
    end

    def rack_groups
      @rack_groups = RackGroup.where(site_id: params[:site_id]).all
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
        process_success object: @rack
      else
        process_error object: @rack
      end
    end

    private

    def set_rack
      @rack = ForemanDatacenter::Rack.find(params[:id])
    end

    def rack_params
      params[:rack].
        permit(:site_id, :rack_group_id, :name, :facility_id, :height, :comments)
    end
  end
end
