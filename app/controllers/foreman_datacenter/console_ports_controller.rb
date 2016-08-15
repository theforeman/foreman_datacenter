module ForemanDatacenter
  class ConsolePortsController < ApplicationController
    before_action :set_console_port, only: [:edit, :update, :destroy,
                                            :connected, :planned]

    def new
      @console_port = ConsolePort.new
    end

    def edit
    end

    def create
      @console_port = ConsolePort.new(console_port_params)

      if @console_port.save
        redirect_to @console_port, notice: 'Console port was successfully created.'
      else
        render :new
      end
    end

    def update
      if @console_port.update(console_port_params)
        redirect_to @console_port, notice: 'Console port was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @console_port.destroy
      redirect_to console_ports_url, notice: 'Console port was successfully destroyed.'
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

    private

    def set_console_port
      @console_port = ConsolePort.find(params[:id])
    end

    def console_port_params
      params[:console_port]
    end
  end
end
