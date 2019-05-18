module ForemanDatacenter::Controller::Parameters::ConsoleServerPortTemplate
  extend ActiveSupport::Concern

  class_methods do
    def console_server_port_template_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::ConsoleServerPortTemplate).tap do |filter|
        filter.permit :device_type_id, :name
      end
    end
  end

  def console_server_port_template_params
    self.class.console_server_port_template_params_filter.filter_params(params, parameter_filter_context)
  end
end
