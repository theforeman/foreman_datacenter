module ForemanDatacenter::Controller::Parameters::PowerOutlet
  extend ActiveSupport::Concern

  class_methods do
    def power_outlet_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::PowerOutlet).tap do |filter|
        filter.permit :device_id, :name
      end
    end
  end

  def power_outlet_params
    self.class.power_outlet_params_filter.filter_params(params, parameter_filter_context)
  end
end
