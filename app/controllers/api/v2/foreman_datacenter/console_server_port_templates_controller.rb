module Api
  module V2
    module ForemanDatacenter
      class ConsoleServerPortTemplatesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::ConsoleServerPortTemplate

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{destroy show}
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/console_server_port_templates/", N_("List all ConsoleServerPortTemplates")

        def index
          @console_server_port_templates = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/console_server_port_templates/:id/", N_("Show a ConsoleServerPortTemplate")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :console_server_port_template do
	  param :console_server_port_template, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_type_id, :number, :desc => N_("DeviceType ID")
	  end
	end

	api :POST, "/foreman_datacenter/console_server_port_templates", N_("Create a ConsoleServerPortTemplate")
	param_group :console_server_port_template, :as => :create

	def create
	  @console_server_port_template = ::ForemanDatacenter::ConsoleServerPortTemplate.new(console_server_port_template_params)
	  process_response @console_server_port_template.save
	end

	api :DELETE, "/foreman_datacenter/console_server_port_templates/:id/", N_("Delete a ConsoleServerPortTemplate")
	param :id, :identifier, :required => true

	def destroy
	  process_response @console_server_port_template.destroy
	end
      end
    end
  end
end
