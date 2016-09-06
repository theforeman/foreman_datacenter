module ForemanDatacenter
  class ManagementDevicesController < ApplicationController
    before_action :set_management_device, only: [:edit, :update, :destroy]

    def new
      device = Device.find(params[:device_id])
      @management_device = ManagementDevice.new(device: device)
    end

    def edit
    end

    def create
      @management_device = ManagementDevice.new(management_device_params)

      if @management_device.save
        redirect_to device_url(@management_device.device),
                    notice: 'New management device was successfully created'
      else
        process_error object: @management_device
      end
    end

    def update
      if @management_device.update(management_device_params)
        redirect_to device_url(@management_device.device),
                    notice: 'Management device was successfully updated'
      else
        process_error object: @management_device
      end
    end

    def destroy
      if @management_device.destroy
        redirect_to device_url(@management_device.device),
                    notice: 'Management device was successfully destroyed'
      else
        process_error object: @management_device
      end
    end

    private

    def set_management_device
      @management_device = ManagementDevice.find(params[:id])
    end

    def management_device_params
      params[:management_device].permit(:device_id, :name, :login, :password)
    end
  end
end
