module ForemanDatacenter
  class DeviceInterfaceConnectionsController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::DeviceInterfaceConnection

    before_action :find_resource, only: [:destroy, :planned, :connected, :edit]

    def index
      @device_interface_connections = resource_base_search_and_page.includes(second_interface: [:device], first_interface: [:device])
    end

    def new
      @device_interface_connection = ForemanDatacenter::DeviceInterfaceConnection.connected.new(
        first_interface: get_device_interface
      )
    end

    def edit
      @device = @device_interface_connection.first_device
    end

    def create
      @device_interface_connection = ForemanDatacenter::DeviceInterfaceConnection.new(device_interface_connection_params.merge(interface_a: params[:device_interface_id]))
      @device_interface_connection.first_interface = get_device_interface

      if @device_interface_connection.save
        process_success(success_msg: "Connection was successfully created.", success_redirect: device_url(id: @device_interface_connection.first_interface.device))
      else
        process_error object: @device_interface_connection
      end
    end

    def destroy
      @device_interface_connection.destroy
      head :ok
    end

    def planned
      @device_interface_connection.planned!
      head :ok
    end

    def connected
      @device_interface_connection.connected!
      head :ok
    end

    def interfaces
      @interfaces = ForemanDatacenter::Device.find(params[:device_id]).free_interfaces
      render partial: 'interfaces'
    end

    private

    def get_device_interface
      ForemanDatacenter::DeviceInterface.find(params[:device_interface_id])
    end
  end
end
