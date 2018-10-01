module ForemanDatacenter::Controller::Parameters::Device
  extend ActiveSupport::Concern

  class_methods do
    def device_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Device).tap do |filter|
        filter.permit :device_type_id, :device_role_id, :platform_id,
                      :name, :serial, :rack_id, :position, :side,
                      :face, :status, :primary_ip4, :primary_ip6,
                      :host_id, :size
      end
    end
  end

  def device_params
    self.class.device_params_filter.filter_params(params, parameter_filter_context)
  end
end
 
