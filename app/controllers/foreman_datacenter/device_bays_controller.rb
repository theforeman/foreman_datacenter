module ForemanDatacenter
  class DeviceBaysController < ApplicationController
    before_action :set_device_bay, only: [:depopulate, :populate,
                                          :populate_new, :edit, :update, :destroy]

    def new
      @device_bay = DeviceBay.new(device: Device.find(params[:device_id]))
    end

    def edit
    end

    def create
      @device_bay = DeviceBay.new(device_bay_params)

      if @device_bay.save
        redirect_to device_url(@device_bay.device),
                    notice: 'New device bay was successfully created'
      else
        process_error object: @device_bay
      end
    end

    def update
      if @device_bay.update(device_bay_params)
        redirect_to device_url(@device_bay.device),
                    notice: 'Device bay was successfully updated'
      else
        process_error object: @device_bay
      end
    end

    def destroy
      if @device_bay.destroy
        redirect_to device_url(@device_bay.device),
                    notice: 'Device bay was successfully destroyed'
      else
        process_error object: @device_bay
      end
    end

    def populate_new
    end

    def populate
      device_id = params[:device_bay][:installed_device_id]
      if @device_bay.update(installed_device_id: device_id)
        redirect_to device_url(@device_bay.device),
                    notice: 'Device bay was successfully populated'
      else
        process_error object: @device_bay
      end
    end

    def depopulate
      if @device_bay.update(installed_device_id: nil)
        redirect_to device_url(@device_bay.device),
                    notice: 'Device bay was successfully depopulated'
      else
        process_error object: @device_bay
      end
    end

    private

    def set_device_bay
      @device_bay = DeviceBay.find(params[:id])
    end

    def device_bay_params
      params[:device_bay].permit(:name, :device_id)
    end
  end
end
