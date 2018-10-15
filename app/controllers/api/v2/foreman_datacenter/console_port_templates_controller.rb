module Api
  module V2
    module ForemanDatacenter
      class ConsolePortTemplatesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::ConsolePortTemplate

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{destroy show}
        add_scoped_search_description_for(::ForemanDatacenter::ConsolePortTemplate)
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/console_port_templates/", N_("List all ConsolePortTemplates")
        
        def index
          @console_port_templates = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/console_port_templates/:id/", N_("Show a ConsolePortTemplate")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :console_port_template do
	  param :console_port_template, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true, :desc => N_("CponsolePortTemplate NAME")
	    param :device_type_id, :number, :desc => N_("DeviceType ID")
	  end
	end

	api :POST, "/foreman_datacenter/console_port_templates", N_("Create a ConsolePortTemplate")
	param_group :console_port_template, :as => :create

	def create
	  @console_port_template = ::ForemanDatacenter::ConsolePortTemplate.new(console_port_template_params)
	  process_response @console_port_template.save
	end

	api :DELETE, "/foreman_datacenter/console_port_templates/:id/", N_("Delete a ConsolePortTemplate")
	param :id, :identifier, :required => true

	def destroy
	  process_response @console_port_template.destroy
	end
      end
    end
  end
end
