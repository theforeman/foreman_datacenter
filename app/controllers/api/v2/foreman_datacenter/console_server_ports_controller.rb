module Api
  module V2
    module ForemanDatacenter
      class ConsoleServerPortsController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::ConsoleServerPort

        before_action :find_resource, :only => %w{show update destroy connect connected planned disconnect}
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/console_server_ports/", N_("List all ConsoleServerPorts")

        def index
          @console_server_ports = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/console_server_ports/:id/", N_("Show a ConsoleServerPort")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :console_server_port do
	  param :console_server_port, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :desc => N_("Device ID")
	  end
	end

	api :POST, "/foreman_datacenter/console_server_ports", N_("Create a ConsoleServerPort")
	param_group :console_server_port, :as => :create

	def create
	  @console_server_port = ::ForemanDatacenter::ConsoleServerPort.new(console_server_port_params)
	  process_response @console_server_port.save
	end

	api :PUT, "/foreman_datacenter/console_server_ports/:id/", N_("Update a ConsoleServerPort")
	param :id, :identifier, :required => true
	param_group :console_server_port

	def update
	  process_response @console_server_port.update(console_server_port_params)
	end

	api :DELETE, "/foreman_datacenter/console_server_ports/:id/", N_("Delete a ConsoleServerPort")
	param :id, :identifier, :required => true

	def destroy
	  process_response @console_server_port.destroy
	end

	api :PATCH, "/foreman_datacenter/console_server_ports/:id/connect", N_("Connect")
	param :id, :identifier, :required => true
	param_group :console_server_port
        param :console_port_id, :number, :desc => N_("ConsolePort ID"), :required => true
        param :connection_status, :number, :desc => N_("Connections status"), :required => true, :default_value => 0

	def connect
          console_port = ::ForemanDatacenter::ConsolePort.find(params[:console_port_id])
          console_port.connect(
            @console_server_port,
            params[:connection_status]
          )
	end

	api :PATCH, "/foreman_datacenter/console_server_ports/:id/disconnect", N_("Disconnect")
	param :id, :identifier, :required => true
	param_group :console_server_port

	def disconnect
          process_response @console_server_port.console_port.disconnect
	end
      end
    end
  end
end
