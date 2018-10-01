  module ForemanDatacenter::Controller::Parameters::Comment
  extend ActiveSupport::Concern

  class_methods do
    def comment_params_filter
      Foreman::ParameterFilter.new(::ForemanDatacenter::Comment).tap do |filter|
        filter.permit :content, :commntable_type,
                      :commentable_id, :parent_id, :user_id
      end
    end
  end

  def comment_params
    self.class.comment_params_filter.filter_params(params, parameter_filter_context)
  end
end
 
