module ForemanDatacenter
  class DeviceInterfacesController < ApplicationController
    before_action :set_device_interface, only: [:edit, :update, :destroy]

    def new
      device = Device.find(params[:device_id])
      @device_interface = DeviceInterface.new(
        device: device,
        form_factor: DeviceInterface::DEFAULT_FORM_FACTOR
      )
    end

    def edit
    end

    def create
      @device_interface = DeviceInterface.new(device_interface_params)

      if @device_interface.save
        redirect_to device_url(id: @device_interface.device_id),
                    notice: 'Device interface was successfully created.'
      else
        process_error object: @device_interface
      end
    end

    def update
      if @device_interface.update(device_interface_params)
        redirect_to device_url(id: @device_interface.device_id),
                    notice: 'Device interface was successfully updated.'
      else
        process_error object: @device_interface
      end
    end

    def destroy
      if @device_interface.destroy
        redirect_to device_url(id: @device_interface.device_id),
                    notice: 'Device interface was successfully destroyed.'
      else
        process_error object: @device_interface
      end
    end

    private

    def set_device_interface
      @device_interface = DeviceInterface.find(params[:id])
    end

    def device_interface_params
      params[:device_interface].
        permit(:device_id, :name, :form_factor, :mac_address, :mgmt_only, :description)
    end
  end
end
