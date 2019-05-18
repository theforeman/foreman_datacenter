module ForemanDatacenter::Controller::Parameters::DeviceInterface
  extend ActiveSupport::Concern

  class_methods do
    def device_interface_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceInterface).tap do |filter|
        filter.permit :device_id, :name, :form_factor,
                      :mac_address, :mgmt_only, :description,
                      :ip_address
      end
    end
  end

  def device_interface_params
    self.class.device_interface_params_filter.filter_params(params, parameter_filter_context)
  end
end
