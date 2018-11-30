module ForemanDatacenter::Controller::Parameters::ManagementDevice
  extend ActiveSupport::Concern

  class_methods do
    def management_device_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Rack).tap do |filter|
        filter.permit :device_id, :console_url, :login, :password
      end
    end
  end

  def management_device_params
    self.class.management_device_params_filter.filter_params(params, parameter_filter_context)
  end
end
