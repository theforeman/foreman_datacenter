  module ForemanDatacenter::Controller::Parameters::DeviceBayTemplate
  extend ActiveSupport::Concern

  class_methods do
    def device_bay_template_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceBayTemplate).tap do |filter|
        filter.permit :name, :device_type_id
      end
    end
  end

  def device_bay_template_params
    self.class.device_bay_template_params_filter.filter_params(params, parameter_filter_context)
  end
end
