module ForemanDatacenter::Controller::Parameters::PowerPort
  extend ActiveSupport::Concern

  class_methods do
    def power_port_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::PowerPort).tap do |filter|
        filter.permit :device_id, :name
      end
    end
  end

  def power_port_params
    self.class.power_port_params_filter.filter_params(params, parameter_filter_context)
  end
end
