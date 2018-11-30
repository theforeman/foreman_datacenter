module ForemanDatacenter
  class PlatformsController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Platform

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @platforms = resource_base_search_and_page
    end

    def show
    end

    def new
      @platform = Platform.new
    end

    def edit
    end

    def create
      @platform = Platform.new(platform_params)

      if @platform.save
        process_success object: @platform
      else
        process_error object: @platform
      end
    end

    def update
      if @platform.update(platform_params)
        process_success object: @platform
      else
        process_error object: @platform
      end
    end

    def destroy
      unless params['object_only']
        @platform.devices.each { |d| d.destroy }
      else
        @platform.devices.delete_all(:nullify)
      end
      if @platform.destroy
        process_success success_redirect: platforms_path
      else
        process_error object: @platform
      end
    end
  end
end
