  module ForemanDatacenter::Controller::Parameters::DeviceInterfaceConnection
  extend ActiveSupport::Concern

  class_methods do
    def device_interface_connection_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceInterfaceConnection).tap do |filter|
        filter.permit :interface_a, :interface_b, :connection_status
      end
    end
  end

  def device_interface_connection_params
    self.class.device_interface_connection_params_filter.filter_params(params, parameter_filter_context)
  end
end
 

