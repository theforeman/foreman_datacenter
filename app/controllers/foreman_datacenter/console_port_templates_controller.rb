module ForemanDatacenter
  class ConsolePortTemplatesController < ApplicationController
    before_action :set_console_port_template, only: [:destroy]

    def new
      @console_port_template = ConsolePortTemplate.new(
        device_type: DeviceType.find(params[:device_type_id]),
      )
    end

    def create
      @console_port_template = ConsolePortTemplate.new(console_port_template_params)

      if @console_port_template.save
        redirect_to device_type_url(@console_port_template.device_type),
                    notice: 'New console port template was successfully created'
      else
        process_error object: @console_port_template
      end
    end

    def destroy
      if @console_port_template.destroy
        redirect_to device_type_url(@console_port_template.device_type),
                    notice: 'Console port template was successfully destroyed'
      else
        process_error object: @console_port_template
      end
    end

    private

    def set_console_port_template
      @console_port_template = ConsolePortTemplate.find(params[:id])
    end

    def console_port_template_params
      params[:console_port_template].permit(:device_type_id, :name)
    end
  end
end
