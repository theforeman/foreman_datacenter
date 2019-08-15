module ForemanDatacenter
  class DeviceModulesController < ApplicationController
    include ForemanDatacenter::Controller::Parameters::DeviceModule

    before_action :find_resource, only: [:edit, :update, :destroy]

    def new
      @device_module = ForemanDatacenter::DeviceModule.new(
        device: ForemanDatacenter::Device.find(params[:device_id])
      )
    end

    def edit
    end

    def create
      @device_module = ForemanDatacenter::DeviceModule.new(device_module_params.merge(device_id: params[:device_id]))
      if @device_module.save
        process_success(success_msg: "Device module was successfully created.", success_redirect: inventory_device_url(id: @device_module.device_id))
      else
        process_error object: @device_module
      end
    end

    def update
      if @device_module.update(device_module_params)
        process_success(success_msg: "Device module was successfully updated.", success_redirect: inventory_device_url(id: @device_module.device_id))
      else
        process_error object: @device_module
      end
    end

    def destroy
      if @device_module.destroy
        process_success(success_msg: "Device module was successfully destroyed.", success_redirect: inventory_device_url(id: @device_module.device_id))
      else
        process_error object: @device_module
      end
    end
  end
end
