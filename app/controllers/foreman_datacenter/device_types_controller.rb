module ForemanDatacenter
  class DeviceTypesController < ApplicationController
    before_action :set_device_type, only: [:show, :edit, :update, :destroy]

    def index
      @device_types = DeviceType.includes(:manufacturer).
        paginate(:page => params[:page], :per_page => params[:per_page])
    end

    def show
    end

    def new
      @device_type = DeviceType.new(u_height: 1, is_full_depth: true,
                                    is_console_server: false, is_pdu: false,
                                    is_network_device: true)
    end

    def edit
    end

    def create
      @device_type = DeviceType.new(device_type_params)

      if @device_type.save
        process_success object: @device_type
      else
        process_error object: @device_type
      end
    end

    def update
      if @device_type.update(device_type_params)
        redirect_to device_type_url(@device_type),
                    notice: 'Device type was successfully updated'
      else
        process_error object: @device_type
      end
    end

    def destroy
      if @device_type.destroy
        process_success object: @device_type
      else
        process_error object: @device_type
      end
    end

    private

    def set_device_type
      @device_type = DeviceType.find(params[:id])
    end

    def device_type_params
      params[:device_type].permit(:manufacturer_id, :model, :u_height,
                                  :is_full_depth, :is_console_server,
                                  :is_pdu, :is_network_device, :subdevice_role)
    end
  end
end
