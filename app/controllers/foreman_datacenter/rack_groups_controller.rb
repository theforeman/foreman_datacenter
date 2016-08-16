module ForemanDatacenter
  class RackGroupsController < ApplicationController
    before_action :set_rack_group, only: [:show, :edit, :update, :destroy]

    def index
      @rack_groups = RackGroup.includes(:site, :racks).all
    end

    def show
    end

    def new
      @rack_group = RackGroup.new
    end

    def edit
    end

    def create
      @rack_group = RackGroup.new(rack_group_params)

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
      if @rack_group.destroy
        process_success object: @rack_group
      else
        process_error object: @rack_group
      end
    end

    private

    def set_rack_group
      @rack_group = RackGroup.find(params[:id])
    end

    def rack_group_params
      params[:rack_group].permit(:name, :site_id)
    end
  end
end
