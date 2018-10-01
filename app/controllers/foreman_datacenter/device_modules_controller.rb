module ForemanDatacenter
  class DeviceModulesController < ApplicationController
    include ForemanDatacenter::Controller::Parameters::DeviceModule

    before_action :find_resource, only: [:edit, :update, :destroy]

    def new
      @device_module = DeviceModule.new(
        device: Device.find(params[:device_id])
      )
    end

    def edit
    end

    def create
      @device_module = DeviceModule.new(device_module_params)

      if @device_module.save
        redirect_to inventory_device_url(id: @device_module.device_id),
                    notice: 'Device module was successfully created.'
      else
        process_error object: @device_module
      end
    end

    def update
      if @device_module.update(device_module_params)
        redirect_to inventory_device_url(id: @device_module.device_id),
                    notice: 'Device module was successfully updated.'
      else
        process_error object: @device_module
      end
    end

    def destroy
      if @device_module.destroy
        redirect_to inventory_device_url(id: @device_module.device_id),
                    notice: 'Device module was successfully destroyed.'
      else
        process_error object: @device_module
      end
    end
  end
end
