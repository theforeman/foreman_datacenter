module ForemanDatacenter
  class DeviceBaysController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::DeviceBay

    before_action :find_resource, only: [:depopulate, :populate,
                                         :populate_new, :edit,
                                         :update, :destroy]

    def new
      @device_bay = ForemanDatacenter::DeviceBay.new(device: ForemanDatacenter::Device.find(params[:device_id]))
    end

    def edit
    end

    def create
      @device_bay = ForemanDatacenter::DeviceBay.new(device_bay_params.merge(device_id: params[:device_id]))

      if @device_bay.save
        process_success(success_msg: "New device bay was successfully created.", success_redirect: device_url(id: @device_bay.device))
      else
        process_error object: @device_bay
      end
    end

    def update
      if @device_bay.update(device_bay_params)
        process_success(success_msg: "Device bay was successfully updated.", success_redirect: device_url(id: @device_bay.device))
      else
        process_error object: @device_bay
      end
    end

    def destroy
      if @device_bay.destroy
        process_success(success_msg: "Device bay was successfully destroyed.", success_redirect: device_url(id: @device_bay.device))
      else
        process_error object: @device_bay
      end
    end

    def populate_new
    end

    def populate
      device_id = params[:device_bay][:installed_device_id]
      if @device_bay.update(installed_device_id: device_id)
        process_success(success_msg: "Device bay was successfully populated.", success_redirect: device_url(id: @device_bay.device))
      else
        process_error object: @device_bay
      end
    end

    def depopulate
      if @device_bay.update(installed_device_id: nil)
        process_success(success_msg: "Device bay was successfully depopulated.", success_redirect: device_url(id: @device_bay.device))
      else
        process_error object: @device_bay
      end
    end
  end
end
