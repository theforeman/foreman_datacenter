module Api
  module V2
    module ForemanDatacenter
      class PowerOutletTemplatesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::PowerOutletTemplate

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{destroy show}
        param_group :search_and_pagination, ::Api::V2::BaseController

        api :GET, "/foreman_datacenter/power_outlet_templates/", N_("List all PowerOutletTemplates")
        
        def index
          @power_outlet_templates = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/power_outlet_templates/:id/", N_("Show a PowerOutletTemplates")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :power_outlet_template do
	  param :power_outlet_template, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_type_id, :number, :desc => N_("DeviceType ID")
	  end
	end

	api :POST, "/foreman_datacenter/power_outlet_templates", N_("Create a PowerOutletTemplate")
	param_group :power_outlet_template, :as => :create

	def create
	  @power_outlet_template = ::ForemanDatacenter::PowerOutletTemplate.new(power_outlet_template_params)
	  process_response @power_outlet_template.save
	end

	api :DELETE, "/foreman_datacenter/power_outlet_templates/:id/", N_("Delete a PowerOutletTemplate")
	param :id, :identifier, :required => true

	def destroy
	  process_response @power_outlet_template.destroy
	end

      end
    end
  end
end
