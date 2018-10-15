  module ForemanDatacenter::Controller::Parameters::ConsoleServerPort
  extend ActiveSupport::Concern

  class_methods do
    def console_server_port_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::ConsoleServerPort).tap do |filter|
        filter.permit :device_id, :name
      end
    end
  end

  def console_server_port_params
    self.class.console_server_port_params_filter.filter_params(params, parameter_filter_context)
  end
end
