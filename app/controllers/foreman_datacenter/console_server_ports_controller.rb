module ForemanDatacenter
  class ConsoleServerPortsController < ApplicationController
    before_action :set_console_server_port, only: [:edit, :update, :destroy,
                                                   :new_connection, :connect,
                                                   :disconnect]

    def new
      device = Device.find(params[:device_id])
      @console_server_port = ConsoleServerPort.new(device: device)
    end

    def edit
    end

    def create
      @console_server_port = ConsoleServerPort.new(console_server_port_params)

      if @console_server_port.save
        redirect_to device_url(id: @console_server_port.device_id),
                    notice: 'Console server port was successfully created.'
      else
        process_error object: @console_server_port
      end
    end

    def update
      if @console_server_port.update(console_server_port_params)
        redirect_to device_url(id: @console_server_port.device_id),
                    notice: 'Console server port was successfully updated.'
      else
        process_error object: @console_server_port
      end
    end

    def destroy
      if @console_server_port.destroy
        redirect_to device_url(id: @console_server_port.device_id),
                    notice: 'Console server port was successfully destroyed.'
      else
        process_error object: @console_server_port
      end
    end

    def new_connection
    end

    def connect
      console_port = ConsolePort.find(params[:console_port][:id])
      console_port.connect(
        @console_server_port,
        params[:console_port][:connection_status]
      )
      redirect_to device_url(id: @console_server_port.device_id),
                  notice: 'Console server port was successfully connected.'
    end

    def disconnect
      @console_server_port.console_port.disconnect
      redirect_to device_url(id: @console_server_port.device_id),
                  notice: 'Console server port was successfully disconnected.'
    end

    def for_device
      @device = Device.find(params[:device_id])
      render partial: 'for_device'
    end

    private

    def set_console_server_port
      @console_server_port = ConsoleServerPort.find(params[:id])
    end

    def console_server_port_params
      params[:console_server_port].permit(:device_id, :name)
    end
  end
end
