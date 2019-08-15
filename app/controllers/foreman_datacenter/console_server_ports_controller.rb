module ForemanDatacenter
  class ConsoleServerPortsController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::ConsoleServerPort

    before_action :find_resource, only: [:edit, :update, :destroy,
                                         :new_connection, :connect,
                                         :disconnect]

    def new
      device = ForemanDatacenter::Device.find(params[:device_id])
      @console_server_port = ForemanDatacenter::ConsoleServerPort.new(device: device)
    end

    def edit
    end

    def create
      @console_server_port = ForemanDatacenter::ConsoleServerPort.new(console_server_port_params.merge(device_id: params[:device_id]))

      if @console_server_port.save
        process_success(success_msg: "Console server port was successfully created.", success_redirect: device_url(id: @console_server_port.device_id))
      else
        process_error object: @console_server_port
      end
    end

    def update
      if @console_server_port.update(console_server_port_params)
        process_success(success_msg: "Console server port was successfully updated.", success_redirect: device_url(id: @console_server_port.device_id))
      else
        process_error object: @console_server_port
      end
    end

    def destroy
      if @console_server_port.destroy
        process_success(success_msg: "Console server port was successfully destroyed.", success_redirect: device_url(id: @console_server_port.device_id))
      else
        process_error object: @console_server_port
      end
    end

    def new_connection
    end

    def connect
      console_port = ForemanDatacenter::ConsolePort.find(params[:console_port][:id])
      console_port.connect(
        @console_server_port,
        params[:console_port][:connection_status]
      )
      process_success(success_msg: "Console server port was successfully connected.", success_redirect: device_url(id: @console_server_port.device_id))
    end

    def disconnect
      @console_server_port.console_port.disconnect
      process_success(success_msg: "Console server port was successfully disconnected.", success_redirect: device_url(id: @console_server_port.device_id))
    end

    def for_device
      @device = ForemanDatacenter::Device.find(params[:device_id])
      render partial: 'for_device'
    end
  end
end
