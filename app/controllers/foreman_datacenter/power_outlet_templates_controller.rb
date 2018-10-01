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
      @power_outlet_template = PowerOutletTemplate.new(power_outlet_template_params)

      if @power_outlet_template.save
        redirect_to device_type_url(@power_outlet_template.device_type),
                    notice: 'New power outlet template was successfully created'
      else
        process_error object: @power_outlet_template
      end
    end

    def destroy
      if @power_outlet_template.destroy
        redirect_to device_type_url(@power_outlet_template.device_type),
                    notice: 'Power outlet template was successfully destroyed'
      else
        process_error object: @power_outlet_template
      end
    end
  end
end
