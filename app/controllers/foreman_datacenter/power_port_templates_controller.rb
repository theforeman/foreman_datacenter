module ForemanDatacenter
  class PowerPortTemplatesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::PowerPortTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @power_port_template = ForemanDatacenter::PowerPortTemplate.new(
        device_type: ForemanDatacenter::DeviceType.find(params[:device_type_id]),
      )
    end

    def create
      @power_port_template = ForemanDatacenter::PowerPortTemplate.new(power_port_template_params.merge(device_type_id: params[:device_type_id]))

      if @power_port_template.save
        process_success success_redirect: device_type_url(@power_port_template.device_type_id)
      else
        process_error object: @power_port_template
      end
    end

    def destroy
      if @power_port_template.destroy
        process_success success_redirect: device_type_url(params[:device_type_id])
      else
        process_error object: @power_port_template
      end
    end
  end
end
