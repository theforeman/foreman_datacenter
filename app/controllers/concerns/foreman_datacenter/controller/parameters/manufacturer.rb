module ForemanDatacenter::Controller::Parameters::Manufacturer
  extend ActiveSupport::Concern

  class_methods do
    def manufacturer_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Manufacturer).tap do |filter|
        filter.permit :name
      end
    end
  end

  def manufacturer_params
    self.class.manufacturer_params_filter.filter_params(params, parameter_filter_context)
  end
end
