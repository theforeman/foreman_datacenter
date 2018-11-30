module ForemanDatacenter::Controller::Parameters::RackGroup
  extend ActiveSupport::Concern

  class_methods do
    def rack_group_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::RackGroup).tap do |filter|
        filter.permit :name, :site_id
      end
    end
  end

  def rack_group_params
    self.class.rack_group_params_filter.filter_params(params, parameter_filter_context)
  end
end
