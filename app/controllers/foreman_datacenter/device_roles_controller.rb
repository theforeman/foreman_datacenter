module ForemanDatacenter
  class DeviceRolesController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::DeviceRole

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @device_roles = resource_base_search_and_page.includes(:devices)
    end

    def show
    end

    def new
      @device_role = DeviceRole.new
    end

    def edit
    end

    def create
      @device_role = DeviceRole.new(device_role_params)

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
      if @device_role.destroy
        process_success object: @device_role
      else
        process_error object: @device_role
      end
    end
  end
end
