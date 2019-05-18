module Api
  module V2
    module ForemanDatacenter
      class ConsolePortsController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::ConsolePort

        before_action :find_resource, :only => %w{show update destroy connect connected planned disconnect}

        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/console_ports/", N_("List all ConsolePorts")

        def index
          # only connected/planned ports
          @console_ports = resource_scope_for_index.where.not(console_server_port_id: nil)
        end

        api :GET, "/foreman_datacenter/console_ports/:id/", N_("Show a ConsolePort")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :console_port do
	  param :console_port, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :desc => N_("Device ID")
	  end
	end

	api :POST, "/foreman_datacenter/console_ports", N_("Create a ConsolePort")
	param_group :console_port, :as => :create

	def create
	  @console_port = ::ForemanDatacenter::ConsolePort.new(console_port_params)
	  process_response @console_port.save
	end

	api :PUT, "/foreman_datacenter/console_ports/:id/", N_("Update a ConsolePort")
	param :id, :identifier, :required => true
	param_group :console_port

	def update
	  process_response @console_port.update(console_port_params)
	end

	api :DELETE, "/foreman_datacenter/console_ports/:id/", N_("Delete a ConsolePort")
	param :id, :identifier, :required => true

	def destroy
	  process_response @console_port.destroy
	end

	api :PATCH, "/foreman_datacenter/console_ports/:id/connect", N_("Connect")
	param :id, :identifier, :required => true
	param_group :console_port
        param :console_server_port_id, :number, :desc => N_("ConsoleServerPort ID"), :required => true
        param :connection_status, :number, :desc => N_("Connections status"), :required => true

	def connect
          console_server_port = ::ForemanDatacenter::ConsoleServerPort.find(params[:console_server_port_id])
          @console_port.connect(
            console_server_port,
            params[:connection_status]
          )
	end

	api :PATCH, "/foreman_datacenter/console_ports/:id/connected", N_("Connected")
	param :id, :identifier, :required => true
	param_group :console_port

	def connected
          process_response @console_port.connected!
	end

	api :PATCH, "/foreman_datacenter/console_ports/:id/disconnect", N_("Disconnect")
	param :id, :identifier, :required => true
	param_group :console_port

	def disconnect
          process_response @console_port.disconnect
	end

	api :PATCH, "/foreman_datacenter/console_ports/:id/planned", N_("Planned")
	param :id, :identifier, :required => true
	param_group :console_port

	def planned
          process_response @console_port.planned!
	end
      end
    end
  end
end
