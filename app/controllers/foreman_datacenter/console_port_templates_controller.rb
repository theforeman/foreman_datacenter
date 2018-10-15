module ForemanDatacenter
  class ConsolePortTemplatesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::ConsolePortTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @console_port_template = ConsolePortTemplate.new(
        device_type: DeviceType.find(params[:device_type_id])
      )
    end

    def create
      @console_port_template = ConsolePortTemplate.new(console_port_template_params.merge(device_type_id: params[:device_type_id]))

      if @console_port_template.save
        process_success success_redirect: device_type_url(@console_port_template.device_type_id)
      else
        process_error object: @console_port_template
      end
    end

    def destroy
      if @console_port_template.destroy
        process_success success_redirect: device_type_url(params[:device_type_id])
      else
        process_error object: @console_port_template
      end
    end
  end
end
