  module ForemanDatacenter::Controller::Parameters::DeviceType
  extend ActiveSupport::Concern

  class_methods do
    def device_type_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceType).tap do |filter|
        filter.permit :manufacturer_id, :model, :u_height,
                      :is_full_depth, :is_console_server,
                      :is_pdu, :is_network_device, :subdevice_role
      end
    end
  end

  def device_type_params
    self.class.device_type_params_filter.filter_params(params, parameter_filter_context)
  end
end
 

