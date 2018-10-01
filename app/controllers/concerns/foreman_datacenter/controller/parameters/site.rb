module ForemanDatacenter::Controller::Parameters::Site
  extend ActiveSupport::Concern

  class_methods do
    def site_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Site).tap do |filter|
        filter.permit :name, :facility, :asn,
          :physical_address, :shipping_address, :comments
      end
    end
  end

  def site_params
    self.class.site_params_filter.filter_params(params, parameter_filter_context)
  end
end
