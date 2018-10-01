module ForemanDatacenter::Controller::Parameters::InterfaceTemplate
  extend ActiveSupport::Concern

  class_methods do
    def interface_template_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::InterfaceTemplate).tap do |filter|
        filter.permit :device_type_id, :name, :form_factor, :mgmt_only
      end
    end
  end

  def interface_template_params
    self.class.interface_template_params_filter.filter_params(params, parameter_filter_context)
  end
end
