module ForemanDatacenter
  class ConsolePortsController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::ConsolePort

    before_action :find_resource, only: [:edit, :update, :destroy,
                                         :connected, :planned, :new_connection,
                                         :connect, :disconnect]

    def index
      @console_ports = resource_base_search_and_page.where.not(console_server_port_id: nil).includes(:device, console_server_port: [:device])
      # @console_ports = ConsolePort.where.not(console_server_port_id: nil).
      #   includes(:device, console_server_port: [:device])
    end

    def new
      @console_port = ConsolePort.new(
        device: Device.find(params[:device_id])
      )
    end

    def edit
    end

    def create
      @console_port = ConsolePort.new(console_port_params.merge(device_id: params[:device_id]))

      if @console_port.save
        process_success success_redirect: device_path(@console_port.device_id)
      else
        process_error object: @console_port
      end
    end

    def update
      if @console_port.update(console_port_params)
        process_success success_redirect: device_path(@console_port.device_id)
      else
        process_error object: @console_port
      end
    end

    def destroy
      if @console_port.destroy
        process_success success_redirect: device_path(@console_port.device_id)
      else
        process_error object: @console_port
      end
    end

    def for_device
      @device = Device.find(params[:device_id])
      render partial: 'for_device'
    end

    def connected
      @console_port.connected!
      head :ok
    end

    def planned
      @console_port.planned!
      head :ok
    end

    def new_connection
    end

    def connect
      console_server_port = ConsoleServerPort.find(params[:console_server_port][:id])
      @console_port.connect(
        console_server_port,
        params[:console_port][:connection_status]
      )
      process_success(success_msg: "Console port was successfully connected.", success_redirect: device_url(id: @console_port.device_id))
    end

    def disconnect
      @console_port.disconnect
      process_success(success_msg: "Console port was successfully disconnected.", success_redirect: device_url(id: @console_port.device_id))
    end
  end
end
