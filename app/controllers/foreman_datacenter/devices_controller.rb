module ForemanDatacenter
  class DevicesController < ApplicationController
    before_action :set_device, only: [:edit, :update, :destroy, :inventory]

    def index
      @devices = Device.includes(:device_role, :device_type, rack: [:site]).all
    end

    def show
      @device = Device.includes(
        device_bays: [:installed_device],
        console_server_ports: [:console_port],
        power_outlets: [:power_port],
        console_ports: [:console_server_port],
        power_ports: [:power_outlet]
      ).find(params[:id])
    end

    def inventory
    end

    def new
      @device = Device.new
    end

    def edit
    end

    def create
      @device = Device.new(device_params)

      if @device.save
        process_success object: @device
      else
        process_error object: @device
      end
    end

    def update
      if @device.update(device_params)
        process_success object: @device
      else
        process_error object: @device
      end
    end

    def destroy
      if @device.destroy
        process_success object: @device
      else
        process_error object: @device
      end
    end

    def device_types
      @manufacturer_id = params[:manufacturer_id]
      render partial: 'device_types'
    end

    def racks
      @site_id = params[:site_id]
      render partial: 'racks'
    end

    def for_rack
      @rack = ForemanDatacenter::Rack.find(params[:rack_id])
      render partial: 'for_rack'
    end

    private

    def set_device
      @device = Device.find(params[:id])
    end

    def device_params
      params[:device].permit(:device_type_id, :device_role_id, :platform_id,
                             :name, :serial, :rack_id, :position, :face,
                             :status, :primary_ip4, :primary_ip6, :comments)
    end
  end
end
