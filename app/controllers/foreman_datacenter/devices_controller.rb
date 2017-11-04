require 'rqrcode'
require 'prawn'
require 'prawn/measurement_extensions'

module ForemanDatacenter
  class DevicesController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch

    before_action :set_device, only: [:update, :destroy, :inventory,
                                      :destroy_interfaces, :qr_code]

    before_action :load_resource

    def index
      begin
        search = resource_base.search_for(params[:search], :order => params[:order])
      rescue => e
        error e.to_s
        search = resource_base.search_for ''
      end
      @devices = search.includes(:device_role, :device_type, :site, :rack).
        paginate(:page => params[:page])
    end

    def show
      @device = Device.includes(
        device_bays: [:installed_device],
        console_server_ports: [:console_port],
        power_outlets: [:power_port],
        console_ports: [:console_server_port],
        power_ports: [:power_outlet]
      ).find(params[:id])
      @current_user = User.current
      @commentable = @device
      @comment = Comment.new
    end

    def inventory
    end

    def new
      @device = Device.new
      populate_from_host
    end

    def edit
      @device = Device.find(params[:id])
      populate_from_host
    end

    def create
      @device = Device.new(device_params)

      if @device.save
        process_success object: @device
      else
        process_error object: @device
      end
    end

    def update
      if @device.update(device_params)
        process_success object: @device
      else
        process_error object: @device
      end
    end

    def destroy
      if @device.destroy
        process_success success_redirect: "/datacenter/devices"
      else
        process_error object: @device
      end
    end

    def device_types
      @manufacturer_id = params[:manufacturer_id]
      render partial: 'device_types'
    end

    def racks
      @site_id = params[:site_id]
      render partial: 'racks'
    end

    def for_rack
      @rack = ForemanDatacenter::Rack.find(params[:rack_id])
      render partial: 'for_rack'
    end

    def destroy_interfaces
      @device.non_management_interfaces.
        where(id: params[:interfaces]).
        destroy_all
      redirect_to device_url(@device)
    end

    def qr_code
      send_data(generate_qr_code(@device),
                filename: "#{@device.name_without_fqdn}.qr.pdf",
                type: 'application/pdf')
    end

    private

    def set_device
      @device = Device.find(params[:id])
    end

    def device_params
      params[:device].permit(:device_type_id, :device_role_id, :platform_id,
                             :name, :serial, :rack_id, :position, :side,
                             :face, :status, :primary_ip4, :primary_ip6,
                             :host_id, :size)
    end

    def load_resource
      resource, id = request.path.split('/')[2, 3]
      @commentable_data = {resource: resource, id: id }
    end

    def populate_from_host
      if params[:host_id]
        host = Host.find(params[:host_id])
        @device.populate_from_host(host)
      end
    end

    def generate_qr_code(device)
      name = device.name_without_fqdn
      width = (name.size * 5.5).round + 40 # magic
      qr_code = RQRCode::QRCode.new(device_url(device))
      png = qr_code.as_png(border_modules: 1, size: 240).to_s
      document = Prawn::Document.new(page_size: [36, width * 2], page_layout: :landscape, margin: 0) do
        font_size(10)
        image(StringIO.new(png), width: 36, scale: 1)
        text_box(name, at: [38, 22])
        image(StringIO.new(png), width: 36, scale: 1, at: [width, 36])
        text_box(name, at: [width + 38, 22])
      end
      document.render
    end
  end
end

