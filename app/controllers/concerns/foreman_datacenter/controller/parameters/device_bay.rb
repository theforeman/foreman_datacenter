  module ForemanDatacenter::Controller::Parameters::DeviceBay
  extend ActiveSupport::Concern

  class_methods do
    def device_bay_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::DeviceBay).tap do |filter|
        filter.permit :name, :device_id
      end
    end
  end

  def device_bay_params
    self.class.device_bay_params_filter.filter_params(params, parameter_filter_context)
  end
end
