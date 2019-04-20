require 'rqrcode'
require 'prawn'
require 'prawn/measurement_extensions'

module ForemanDatacenter
  class DevicesController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Device

    before_action :find_resource, only: [:update, :destroy, :inventory,
                                         :destroy_interfaces, :qr_code,
                                         :sync_interfaces_with_host]

    def index
      @devices = resource_base_search_and_page.includes(:device_role, :device_type, :site, :rack, :comments)
    end

    def show
      @device = ForemanDatacenter::Device.includes(
        power_ports: [:power_outlet, :device],
        power_outlets: [:device, :power_port],
        console_ports: [:console_server_port, :device],
        console_server_ports: [:console_port, :device],
        device_bays: [:installed_device],
        comments: [:user]
      ).find(params[:id])
      @comments = @device.comments
      @commentable = @device
      @comment = ForemanDatacenter::Comment.new
      @resource = request.path.split('/')[2]
      @current_user = current_user
    end

    def inventory
    end

    def new
      @device = ForemanDatacenter::Device.new
      populate_from_host
    end

    def edit
      @device = ForemanDatacenter::Device.find(params[:id])
      populate_from_host
    end

    def create
      @device = ForemanDatacenter::Device.new(device_params.merge(host_id: params[:host_id]))

      if @device.save
        process_success success_redirect: device_url(@device)
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
      unless params['object_only']
        if @device.destroy
          process_success success_redirect: "/datacenter/devices"
        else
          process_error object: @device
        end
      else
        if @device.host
          @device.host.destroy
          new_device_name = "Unassigned device (former: #{@device.name})"
          @device.update(name: new_device_name)
          process_success success_redirect: '/datacenter/devices', success_msg: 'Associated host deleted'
        else
          process_error success_redirect: '/datacenter/devices', error_msg: 'Associated host not found'
        end
      end
    end

    def device_types
      @manufacturer_id = params[:manufacturer_id]
      render partial: 'device_types'
    end

    def device_type_size
      @device_type_id = params[:device_type_id]
      render partial: 'device_type_size'
    end

    def racks
      @site_id = params[:site_id]
      render partial: 'racks'
    end

    def site_racks
      @site = ForemanDatacenter::Site.find(params[:site_id])
      render partial: 'site_racks'
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

    def sync_interfaces_with_host
      if @device.sync_interfaces_with_host
        notice("Device successfully synchronized.")
        redirect_to device_url(@device)
      else
        error("Unsuccessful synchronization.")
        redirect_to device_url(@device)
      end
    end

    private

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

