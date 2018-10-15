module ForemanDatacenter
  class PowerPortsController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::PowerPort

    # before_action :find_resource, only: [:edit, :update, :destroy, :connected,
    #                                       :planned, :new_connection, :connect,
    #                                       :disconnect]

    before_action :set_power_port, only: [:edit, :update, :destroy, :connected,
                                          :planned, :new_connection, :connect,
                                          :disconnect]

    def index
      @power_ports = resource_base_search_and_page.where.not(power_outlet_id: nil).includes(:device, power_outlet: [:device])
    end

    def new
      @power_port = ForemanDatacenter::PowerPort.new(
        device: Device.find(params[:device_id])
      )
    end

    def edit
    end

    def create
      @power_port = ForemanDatacenter::PowerPort.new(power_port_params.merge(device_id: params[:device_id]))

      if @power_port.save
        redirect_to device_url(id: @power_port.device_id),
                    notice: 'Power port was successfully created.'
      else
        process_error object: @power_port
      end
    end

    def update
      if @power_port.update(power_port_params)
        redirect_to device_url(id: @power_port.device_id),
                    notice: 'Power port was successfully updated.'
      else
        process_error object: @power_port
      end
    end

    def destroy
      if @power_port.destroy
        redirect_to device_url(id: @power_port.device_id),
                    notice: 'Power port was successfully destroyed.'
      else
        process_error object: @power_port
      end
    end

    def connected
      @power_port.connected!
      head :ok
    end

    def planned
      @power_port.planned!
      head :ok
    end

    def for_device
      @device = Device.find(params[:device_id])
      render partial: 'for_device'
    end

    def new_connection
    end

    def connect
      power_outlet = PowerOutlet.find(params[:power_outlet][:id])
      @power_port.connect(
        power_outlet,
        params[:power_port][:connection_status]
      )
      redirect_to device_url(id: @power_port.device_id),
                  notice: 'Power port was successfully connected.'
    end

    def disconnect
      @power_port.disconnect
      redirect_to device_url(id: @power_port.device_id),
                  notice: 'Power port was successfully disconnected.'
    end

    private

    def set_power_port
      @power_port = PowerPort.find(params[:id])
    end
  end
end
