module Api
  module V2
    module ForemanDatacenter
      class InterfaceTemplatesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::InterfaceTemplate

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{destroy show}
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/interface_templates/", N_("List all InterfaceTemplates")

        def index
          @interface_templates = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/interface_templates/:id/", N_("Show a InterfaceTemplate")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :interface_template do
	  param :interface_template, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_type_id, :number, :desc => N_("DeviceType ID")
	    param :form_factor, :number, :desc => N_("Form factor")
	    param :mgmt_only, :boolean, :desc => N_("mgmt only")
	  end
	end

	api :POST, "/foreman_datacenter/interface_templates", N_("Create a InterfaceTemplate")
	param_group :interface_template, :as => :create

	def create
	  @interface_template = ::ForemanDatacenter::InterfaceTemplate.new(interface_template_params)
	  process_response @interface_template.save
	end

	api :DELETE, "/foreman_datacenter/interface_templates/:id/", N_("Delete a InterfaceTemplate")
	param :id, :identifier, :required => true

	def destroy
	  process_response @interface_template.destroy
	end
      end
    end
  end
end
