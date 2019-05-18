module ForemanDatacenter::Controller::Parameters::DeviceModule
  extend ActiveSupport::Concern

  class_methods do
    def device_module_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceModule).tap do |filter|
        filter.permit :device_id, :name, :part_id, :serial
      end
    end
  end

  def device_module_params
    self.class.device_module_params_filter.filter_params(params, parameter_filter_context)
  end
end
