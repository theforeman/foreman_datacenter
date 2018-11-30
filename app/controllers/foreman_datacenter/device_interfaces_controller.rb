module ForemanDatacenter
  class DeviceInterfacesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::DeviceInterface

    before_action :find_resource, only: [:edit, :update, :destroy]

    def new
      device = ForemanDatacenter::Device.find(params[:device_id])
      @device_interface = DeviceInterface.new(
        device: device,
        form_factor: DeviceInterface::DEFAULT_FORM_FACTOR
      )
    end

    def new_management
      @device_interface = ForemanDatacenter::DeviceInterface.new(
        device: ForemanDatacenter::Device.find(params[:device_id]),
        form_factor: DeviceInterface::DEFAULT_FORM_FACTOR,
        mgmt_only: true
      )
      render :new
    end

    def edit
    end

    def create
      @device_interface = ForemanDatacenter::DeviceInterface.new(device_interface_params.merge(device_id: params[:device_id]))

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
  end
end
