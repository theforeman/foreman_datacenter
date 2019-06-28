module Api
  module V2
    module ForemanDatacenter
      class PowerOutletsController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::PowerOutlet

        before_action :find_resource, :only => %w{show update destroy connect disconnect}
        add_scoped_search_description_for(::ForemanDatacenter::PowerOutletTemplate)
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/power_outlets/", N_("List all PowerOutlets")
        
        def index
          @power_outlets = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/power_outlets/:id/", N_("Show a PowerOutlet")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :power_outlet do
	  param :power_outlet, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_id, :number, :desc => N_("Device ID")
	  end
	end

	api :POST, "/foreman_datacenter/power_outlets", N_("Create a PowerOutlet")
	param_group :power_outlet, :as => :create

	def create
	  @power_outlet = ::ForemanDatacenter::PowerOutlet.new(power_outlet_params)
	  process_response @power_outlet.save
	end

	api :PUT, "/foreman_datacenter/power_outlets/:id/", N_("Update a PowerOutlet")
	param :id, :identifier, :required => true
	param_group :power_outlet

	def update
	  process_response @power_outlet.update(power_outlet_params)
	end

	api :DELETE, "/foreman_datacenter/power_outlets/:id/", N_("Delete a PowerOutlet")
	param :id, :identifier, :required => true

	def destroy
	  process_response @power_outlet.destroy
	end

	api :PATCH, "/foreman_datacenter/power_outlets/:id/connect", N_("Connect")
	param :id, :identifier, :required => true
	param_group :power_outlet
        param :console_server_port_id, :number, :desc => N_("ConsoleServerPort ID"), :required => true
        param :connection_status, :number, :desc => N_("Connections status"), :required => true

	def connect
          power_port = ::ForemanDatacenter::PowerPort.find(params[:power_port_id])
          power_port.connect(
            @power_outlet,
            params[:connection_status]
          )
	end

	api :PATCH, "/foreman_datacenter/power_outlets/:id/disconnect", N_("Disconnect")
	param :id, :identifier, :required => true
	param_group :power_outlet

	def disconnect
          process_response @power_outlet.power_port.disconnect
	end
      end
    end
  end
end
