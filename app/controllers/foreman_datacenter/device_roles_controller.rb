module ForemanDatacenter
  class DeviceRolesController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::DeviceRole

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @device_roles = resource_base_search_and_page
    end

    def show
    end

    def new
      @device_role = ForemanDatacenter::DeviceRole.new
    end

    def edit
    end

    def create
      @device_role = ForemanDatacenter::DeviceRole.new(device_role_params)

      if @device_role.save
        process_success object: @device_role
      else
        process_error object: @device_role
      end
    end

    def update
      if @device_role.update(device_role_params)
        process_success object: @device_role
      else
        process_error object: @device_role
      end
    end

    def destroy
      unless params['object_only']
        @device_role.devices.each { |d| d.destroy }
      else
        @device_role.devices.delete_all(:nullify)
      end

      if @device_role.destroy
        process_success success_redirect: device_roles_path
      else
        process_error object: @device_role
      end
    end
  end
end
