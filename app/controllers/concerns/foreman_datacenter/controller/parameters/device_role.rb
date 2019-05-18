module ForemanDatacenter::Controller::Parameters::DeviceRole
  extend ActiveSupport::Concern

  class_methods do
    def device_role_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceRole).tap do |filter|
        filter.permit :name, :color
      end
    end
  end

  def device_role_params
    self.class.device_role_params_filter.filter_params(params, parameter_filter_context)
  end
end
