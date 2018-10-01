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
      @console_port = ConsolePort.new(console_port_params)

      if @console_port.save
        redirect_to device_url(id: @console_port.device_id),
                    notice: 'Console port was successfully created.'
      else
        process_error object: @console_port
      end
    end

    def update
      if @console_port.update(console_port_params)
        redirect_to device_url(id: @console_port.device_id),
                    notice: 'Console port was successfully updated.'
      else
        process_error object: @console_port
      end
    end

    def destroy
      if @console_port.destroy
        redirect_to device_url(id: @console_port.device_id),
                    notice: 'Console port was successfully destroyed.'
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
      redirect_to device_url(id: @console_port.device_id),
                  notice: 'Console port was successfully connected.'
    end

    def disconnect
      @console_port.disconnect
      redirect_to device_url(id: @console_port.device_id),
                  notice: 'Console port was successfully disconnected.'
    end
  end
end
