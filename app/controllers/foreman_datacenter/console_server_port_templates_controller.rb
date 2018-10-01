module ForemanDatacenter
  class ConsoleServerPortTemplatesController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::ConsoleServerPortTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @console_server_port_template = ConsoleServerPortTemplate.new(
        device_type: DeviceType.find(params[:device_type_id])
      )
    end

    def create
      @console_server_port_template = ConsoleServerPortTemplate.new(console_server_port_template_params)

      if @console_server_port_template.save
        redirect_to device_type_url(@console_server_port_template.device_type),
                    notice: 'New console server port template was successfully created'
      else
        process_error object: @console_server_port_template
      end
    end

    def destroy
      if @console_server_port_template.destroy
        redirect_to device_type_url(@console_server_port_template.device_type),
                    notice: 'Console server port template was successfully destroyed'
      else
        process_error object: @console_server_port_template
      end
    end
  end
end
