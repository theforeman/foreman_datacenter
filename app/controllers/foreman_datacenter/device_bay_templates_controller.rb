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
      @device_bay_template = DeviceBayTemplate.new(device_bay_template_params.merge(device_type_id: params[:device_type_id]))

      if @device_bay_template.save
        process_success success_redirect: device_type_url(@device_bay_template.device_type_id)
      else
        process_error object: @device_bay_template
      end
    end

    def destroy
      if @device_bay_template.destroy
        process_success success_redirect: device_type_url(params[:device_type_id])
      else
        process_error object: @device_bay_template
      end
    end
  end
end
