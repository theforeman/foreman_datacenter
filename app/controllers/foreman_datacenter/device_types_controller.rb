module ForemanDatacenter
  class DeviceTypesController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::DeviceType

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @device_types = resource_base_search_and_page.includes(:manufacturer)
    end

    def show
    end

    def new
      @device_type = ForemanDatacenter::DeviceType.new(u_height: 1, is_full_depth: true,
                                                       is_console_server: false, is_pdu: false,
                                                       is_network_device: true)
    end

    def edit
    end

    def create
      @device_type = ForemanDatacenter::DeviceType.new(device_type_params)

      if @device_type.save
        process_success object: @device_type
      else
        process_error object: @device_type
      end
    end

    def update
      if @device_type.update(device_type_params)
        redirect_to device_type_url(@device_type),
                    notice: 'Device type was successfully updated'
      else
        process_error object: @device_type
      end
    end

    def destroy
      unless params['object_only']
        @device_type.devices.each { |d| d.destroy }
      else
        @device_type.devices.delete_all(:nullify)
      end

      if @device_type.destroy
        process_success success_redirect: device_types_path
      else
        process_error object: @device_type
      end
    end
  end
end
