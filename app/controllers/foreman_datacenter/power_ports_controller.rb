module ForemanDatacenter
  class PowerPortsController < ApplicationController
    before_action :set_power_port, only: [:edit, :update, :destroy, :connected,
                                          :planned]

    def new
      @power_port = PowerPort.new
    end

    def edit
    end

    def create
      @power_port = PowerPort.new(power_port_params)

      if @power_port.save
        redirect_to @power_port, notice: 'Power port was successfully created.'
      else
        render :new
      end
    end

    def update
      if @power_port.update(power_port_params)
        redirect_to @power_port, notice: 'Power port was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @power_port.destroy
      redirect_to power_ports_url, notice: 'Power port was successfully destroyed.'
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

    private

    def set_power_port
      @power_port = PowerPort.find(params[:id])
    end

    def power_port_params
      params[:power_port]
    end
  end
end
