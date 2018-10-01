module ForemanDatacenter
  class ApplicationController < ApplicationController
    before_action :resource_class

    def resource_class
      @resource_class ||= resource_class_for(resource_name)
      raise NameError, "Could not find resource class for resource #{resource_name}" if @resource_class.nil?
      @resource_class
    end

    def resource_class_for(resource)
      klass = "ForemanDatacenter::#{resource.classify}".constantize
    rescue NameError
      nil
    end

  end
end
