module ForemanDatacenter
  module HostsControllerExtensions
    extend ActiveSupport::Concern

    included do
      before_action :set_target_device_for_import, only: :import_to_device
    end

    def import_to_device
      begin
        search = resource_base.search_for(params[:search], :order => params[:order])
      rescue => e
        error e.to_s
        search = resource_base.search_for ''
      end
      @hosts = search.includes(:device, :operatingsystem, :environment, :model, :compute_resource).
        paginate(:page => params[:page], :per_page => params[:per_page])
    end

    private

    def action_permission
      case params[:action]
        when 'import_to_device'
          'view'
        else
          super
      end
    end

    def set_target_device_for_import
      if params[:target_device_id]
        @target_device = Device.find(params[:target_device_id])
      end
    end
  end
end
