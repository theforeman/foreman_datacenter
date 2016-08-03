module ForemanDatacenter
  class DeviceRolesController < ApplicationController
    before_action :set_device_role, only: [:show, :edit, :update, :destroy]

    def index
      @device_roles = DeviceRole.includes(:devices).all
    end

    def show
    end

    def new
      @device_role = DeviceRole.new
    end

    def edit
    end

    def create
      @device_role = DeviceRole.new(device_role_params)

      if @device_role.save
        process_success object: @device_role
      else
        process_error object: @device_role
      end
    end

    def update
      if @device_role.update(device_role_params)
        process_success object: @device_role
      else
        process_error object: @device_role
      end
    end

    def destroy
      if @device_role.destroy
        process_success object: @device_role
      else
        process_error object: @device_role
      end
    end

    private

    def set_device_role
      @device_role = DeviceRole.find(params[:id])
    end

    def device_role_params
      params[:device_role].permit(:name, :color)
    end
  end
end
