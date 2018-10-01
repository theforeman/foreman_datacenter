module ForemanDatacenter::Controller::Parameters::Rack
  extend ActiveSupport::Concern

  class_methods do
    def rack_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Rack).tap do |filter|
        filter.permit :site_id, :rack_group_id, :name,
          :facility_id, :height, :comments
      end
    end
  end

  def rack_params
    self.class.rack_params_filter.filter_params(params, parameter_filter_context)
  end
end
