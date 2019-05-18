module Api
  module V2
    module ForemanDatacenter
      class DeviceBayTemplatesController < ForemanDatacenter::BaseController
	include ::ForemanDatacenter::Controller::Parameters::DeviceBayTemplate

        before_action :find_optional_nested_object
        before_action :find_resource, :only => %w{destroy show}
        param_group :search_and_pagination, ::Api::V2::BaseController
        
        api :GET, "/foreman_datacenter/device_bay_templates/", N_("List all DeviceBayTemplate")
        
        def index
          @device_bay_templates = resource_scope_for_index
        end

        api :GET, "/foreman_datacenter/device_bay_templates/:id/", N_("Show a DeviceBayTemplate")
        param :id, :identifier, :required => true

        def show
        end

	def_param_group :device_bay_template do
	  param :device_bay_template, Hash, :required => true, :action_aware => true do
	    param :name, String, :required => true
	    param :device_type_id, :number, :desc => N_("DeviceType ID")
	  end
	end

	api :POST, "/foreman_datacenter/device_bay_templates", N_("Create a DeviceBayTemplate")
	param_group :device_bay_template, :as => :create

	def create
	  @device_bay_template = ::ForemanDatacenter::DeviceBayTemplate.new(device_bay_template_params)
	  process_response @device_bay_template.save
	end

	api :DELETE, "/foreman_datacenter/device_bay_templates/:id/", N_("Delete a DeviceBayTemplate")
	param :id, :identifier, :required => true

	def destroy
	  process_response @device_bay_template.destroy
	end

      end
    end
  end
end
