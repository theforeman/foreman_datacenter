module ForemanDatacenter
  class InterfaceTemplatesController < ApplicationController
    before_action :set_interface_template, only: [:destroy]

    def new
      @interface_template = InterfaceTemplate.new(
        device_type: DeviceType.find(params[:device_type_id]),
        form_factor: '10GE (SFP+)'
      )
    end

    def create
      @interface_template = InterfaceTemplate.new(interface_template_params)

      if @interface_template.save
        redirect_to device_type_url(@interface_template.device_type),
                    notice: 'New interface template was successfully created'
      else
        process_error object: @interface_template
      end
    end

    def destroy
      if @interface_template.destroy
        redirect_to device_type_url(@interface_template.device_type),
                    notice: 'Interface template was successfully destroyed'
      else
        process_error object: @interface_template
      end
    end

    private

    def set_interface_template
      @interface_template = InterfaceTemplate.find(params[:id])
    end

    def interface_template_params
      params[:interface_template].
        permit(:device_type_id, :name, :form_factor, :mgmt_only)
    end
  end
end
