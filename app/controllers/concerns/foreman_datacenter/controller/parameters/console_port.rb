  module ForemanDatacenter::Controller::Parameters::ConsolePort
  extend ActiveSupport::Concern

  class_methods do
    def console_port_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::ConsolePort).tap do |filter|
        filter.permit :device_id, :name
      end
    end
  end

  def console_port_params
    self.class.console_port_params_filter.filter_params(params, parameter_filter_context)
  end
end
