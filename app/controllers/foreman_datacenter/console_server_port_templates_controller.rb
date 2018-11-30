module ForemanDatacenter
  class ConsoleServerPortTemplatesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::ConsoleServerPortTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @console_server_port_template = ForemanDatacenter::ConsoleServerPortTemplate.new(
        device_type: ForemanDatacenter::DeviceType.find(params[:device_type_id])
      )
    end

    def create
      @console_server_port_template = ForemanDatacenter::ConsoleServerPortTemplate.new(console_server_port_template_params.merge(device_type_id: params[:device_type_id]))

      if @console_server_port_template.save
        process_success success_redirect: device_type_url(@console_server_port_template.device_type_id)
      else
        process_error object: @console_server_port_template
      end
    end

    def destroy
      if @console_server_port_template.destroy
        process_success success_redirect: device_type_url(params[:device_type_id])
      else
        process_error object: @console_server_port_template
      end
    end
  end
end
