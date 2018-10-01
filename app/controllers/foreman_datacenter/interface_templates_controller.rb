module ForemanDatacenter
  class InterfaceTemplatesController < ApplicationController
    include ForemanDatacenter::Controller::Parameters::InterfaceTemplate

    before_action :find_resource, only: [:destroy]

    def new
      @interface_template = InterfaceTemplate.new(
        device_type: DeviceType.find(params[:device_type_id]),
        form_factor: '10GE (SFP+)'
      )
    end

    def new_management
      @interface_template = InterfaceTemplate.new(
        device_type: DeviceType.find(params[:device_type_id]),
        form_factor: '10GE (SFP+)',
        mgmt_only: true
      )
      render :new
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
  end
end
