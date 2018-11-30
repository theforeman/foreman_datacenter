module Api
  module V2
    module ForemanDatacenter
      class PowerPortsController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::PowerPort

        before_action :find_resource, :only => %w{show update destroy connect connected planned disconnect}

        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(::ForemanDatacenter::PowerPort)

        api :GET, "/foreman_datacenter/power_ports/", N_("List all PowerPorts")

        def index
          @power_ports = resource_scope_for_index.where.not(power_outlet_id: nil)
        end

        api :GET, "/foreman_datacenter/power_ports/:id/", N_("Show a PowerPort")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :power_port do
	  param :power_port, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :desc => N_("Device ID")
	  end
	end

	api :POST, "/foreman_datacenter/power_ports", N_("Create a PowerPort")
	param_group :power_port, :as => :create

	def create
	  @power_port = ::ForemanDatacenter::PowerPort.new(power_port_params)
	  process_response @power_port.save
	end

	api :PUT, "/foreman_datacenter/power_ports/:id/", N_("Update a PowerPort")
	param :id, :identifier, :required => true
	param_group :power_port

	def update
	  process_response @power_port.update(power_port_params)
	end

	api :DELETE, "/foreman_datacenter/power_ports/:id/", N_("Delete a PowerPort")
	param :id, :identifier, :required => true

	def destroy
	  process_response @power_port.destroy
	end

	api :PATCH, "/foreman_datacenter/power_ports/:id/connect", N_("Connect")
	param :id, :identifier, :required => true
	param_group :power_port
        param :power_outlet_id, :number, :desc => N_("PowerOutletPort ID"), :required => true
        param :connection_status, :number, :desc => N_("Connections status"), :required => true

	def connect
          power_outlet = ::ForemanDatacenter::PowerOutlet.find(params[:power_outlet_id])
          @power_port.connect(
            power_outlet,
            params[:connection_status]
          )
	end

	api :PATCH, "/foreman_datacenter/power_ports/:id/connected", N_("Connected")
	param :id, :identifier, :required => true
	param_group :power_port

	def connected
          process_response @power_port.connected!
	end

	api :PATCH, "/foreman_datacenter/power_ports/:id/disconnect", N_("Disconnect")
	param :id, :identifier, :required => true
	param_group :power_port

	def disconnect
          process_response @power_port.disconnect
	end

	api :PATCH, "/foreman_datacenter/power_ports/:id/planned", N_("Planned")
	param :id, :identifier, :required => true
	param_group :power_port

	def planned
          process_response @power_port.planned!
	end
      end
    end
  end
end
