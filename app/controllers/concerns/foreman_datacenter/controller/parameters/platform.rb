module ForemanDatacenter::Controller::Parameters::Platform
  extend ActiveSupport::Concern

  class_methods do
    def platform_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Platform).tap do |filter|
        filter.permit :name, :prc_client
      end
    end
  end

  def platform_params
    self.class.platform_params_filter.filter_params(params, parameter_filter_context)
  end
end
