module ForemanDatacenter
  class DeviceBayTemplatesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::DeviceBayTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @device_bay_template = DeviceBayTemplate.new(
        device_type: DeviceType.find(params[:device_type_id])
      )
    end

    def create
      @device_bay_template = DeviceBayTemplate.new(device_bay_template_params)

      if @device_bay_template.save
        redirect_to device_type_url(@device_bay_template.device_type),
                    notice: 'Device bay template was successfully created'
      else
        process_error object: @device_bay_template
      end
    end

    def destroy
      if @device_bay_template.destroy
        redirect_to device_type_url(@device_bay_template.device_type),
                    notice: 'Device bay template was successfully destroyed'
      else
        process_error object: @device_bay_template
      end
    end
  end
end
