module ForemanDatacenter::Controller::Parameters::PowerOutletTemplate
  extend ActiveSupport::Concern

  class_methods do
    def power_outlet_template_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::PowerOutletTemplate).tap do |filter|
        filter.permit :device_type_id, :name
      end
    end
  end

  def power_outlet_template_params
    self.class.power_outlet_template_params_filter.filter_params(params, parameter_filter_context)
  end
end
