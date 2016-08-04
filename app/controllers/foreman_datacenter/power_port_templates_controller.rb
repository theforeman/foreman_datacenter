module ForemanDatacenter
  class PowerPortTemplatesController < ApplicationController
    before_action :set_power_port_template, only: [:destroy]

    def new
      @power_port_template = PowerPortTemplate.new(
        device_type: DeviceType.find(params[:device_type_id]),
      )
    end

    def create
      @power_port_template = PowerPortTemplate.new(power_port_template_params)

      if @power_port_template.save
        redirect_to device_type_url(@power_port_template.device_type),
                    notice: 'New power port template was successfully created'
      else
        process_error object: @power_port_template
      end
    end

    def destroy
      if @power_port_template.destroy
        redirect_to device_type_url(@power_port_template.device_type),
                    notice: 'Power port template was successfully destroyed'
      else
        process_error object: @power_port_template
      end
    end

    private

    def set_power_port_template
      @power_port_template = PowerPortTemplate.find(params[:id])
    end

    def power_port_template_params
      params[:power_port_template].permit(:device_type_id, :name)
    end
  end
end
