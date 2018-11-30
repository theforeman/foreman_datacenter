module ForemanDatacenter::Controller::Parameters::PowerPortTemplate
  extend ActiveSupport::Concern

  class_methods do
    def power_port_template_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::PowerPortTemplate).tap do |filter|
        filter.permit :device_type_id, :name
      end
    end
  end

  def power_port_template_params
    self.class.power_port_template_params_filter.filter_params(params, parameter_filter_context)
  end
end
