module ForemanDatacenter
  class PowerOutletTemplatesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::PowerOutletTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @power_outlet_template = PowerOutletTemplate.new(
        device_type: DeviceType.find(params[:device_type_id])
      )
    end

    def create
      @power_outlet_template = PowerOutletTemplate.new(power_outlet_template_params.merge(device_type_id: params[:device_type_id]))

      if @power_outlet_template.save
        process_success success_redirect: device_type_url(@power_outlet_template.device_type_id)
      else
        process_error object: @power_outlet_template
      end
    end

    def destroy
      if @power_outlet_template.destroy
        process_success success_redirect: device_type_url(params[:device_type_id])
      else
        process_error object: @power_outlet_template
      end
    end
  end
end
