module ForemanDatacenter
  class PowerOutletsController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::PowerOutlet

    before_action :find_resource, only: [:edit, :update, :destroy,
                                         :new_connection,
                                         :connect, :disconnect]

    def new
      device = Device.find(params[:device_id])
      @power_outlet = PowerOutlet.new(device: device)
    end

    def edit
    end

    def create
      @power_outlet = PowerOutlet.new(power_outlet_params.merge(device_id: params[:device_id]))

      if @power_outlet.save
        process_success(success_redirect: device_url(id: @power_outlet.device_id))
      else
        process_error object: @power_outlet
      end
    end

    def update
      if @power_outlet.update(power_outlet_params)
        process_success(success_redirect: device_url(id: @power_outlet.device_id))
      else
        process_error object: @power_outlet
      end
    end

    def destroy
      if @power_outlet.destroy
        process_success(success_redirect: device_url(id: @power_outlet.device_id))
      else
        process_error object: @power_outlet
      end
    end

    def new_connection
    end

    def connect
      power_port = PowerPort.find(params[:power_port][:id])
      power_port.connect(
        @power_outlet,
        params[:power_port][:connection_status]
      )
      process_success(success_msg: "Power outlet was successfully connected.", success_redirect: device_url(id: @power_outlet.device_id))
    end

    def disconnect
      @power_outlet.power_port.disconnect
      process_success(success_msg: "Power outlet was successfully disconnected.", success_redirect: device_url(id: @power_outlet.device_id))
    end

    def for_device
      @device = Device.find(params[:device_id])
      render partial: 'for_device'
    end
  end
end
