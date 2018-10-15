module Api
  module V2
    module ForemanDatacenter
      class DeviceInterfaceConnectionsController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceInterfaceConnection

        before_action :set_device_interface_connection, :only => %w{connected planned}
        before_action :find_resource, :only => %w{show update destroy}
        param_group :search_and_pagination, ::Api::V2::BaseController
        api :GET, "/foreman_datacenter/connections/", N_("List all InterfaceConnections")
        api :GET, "/foreman_datacenter/device_intervace_connections/", N_("List all InterfaceConnections")

        def index
          @device_interface_connections = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_interface_connections/:id/", N_("Show a DeviceInterfaceConnecion")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_interface_connection do
	  param :device_interface_connection, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :interface_a, :number, :desc => N_("Interface A")
	    param :interface_b, :number, :desc => N_("Interface B")
	    param :connection_status, :number, :desc => N_("Connectin status")
	  end
	end

	api :POST, "/foreman_datacenter/device_interfaces/:device_interface_id/device_interface_connections", N_("Create a DeviceInterfaceConnection")
	param_group :device_interface_connection, :as => :create

	def create
          @device_interface_connection = ::ForemanDatacenter::DeviceInterfaceConnection.new(device_interface_connection_params.merge(interface_a: params[:device_interface_id]))
          @device_interface_connection.first_interface = get_device_interface
          @device_interface_connection.save
	end

	api :DELETE, "/foreman_datacenter/device_interface_connections/:id/", N_("Delete a DeviceInterfaceConnection")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_interface_connection.destroy
	end

        api :PATCH, "/foreman_datacenter/device_interface_connections/:id/planned", N_("Planned")
	param :id, :identifier, :required => true
	param_group :device_interface_connection

	def planned
          process_response @device_interface_connection.planned!
	end

        api :PATCH, "/foreman_datacenter/device_interface_connections/:id/connected", N_("Connected")
	param :id, :identifier, :required => true
	param_group :device_interface_connection

	def connected
          process_response @device_interface_connection.connected!
	end

        private

        def get_device_interface
          ::ForemanDatacenter::DeviceInterface.find(params[:device_interface_id])
        end

        def set_device_interface_connection
          @device_interface_connection = ::ForemanDatacenter::DeviceInterfaceConnection.find(params[:id])
        end
      end
    end
  end
end
