module ForemanDatacenter
  class ManufacturersController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::Manufacturer

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @manufacturers = resource_base_search_and_page.includes(:device_types)
    end

    def show
    end

    def new
      @manufacturer = Manufacturer.new
    end

    def edit
    end

    def create
      @manufacturer = Manufacturer.new(manufacturer_params)

      if @manufacturer.save
        process_success object: @manufacturer
      else
        process_error object: @manufacturer
      end
    end

    def update
      if @manufacturer.update(manufacturer_params)
        process_success object: @manufacturer
      else
        process_error object: @manufacturer
      end
    end

    def destroy
      unless params['object_only']
        @manufacturer.device_types.each { |dt| dt.devices.each { |d| d.destroy }; dt.destroy }
      else
        @manufacturer.device_types.delete_all(:nullify)
      end

      if @manufacturer.destroy
        process_success success_redirect: manufacturers_path
      else
        process_error
      end
    end
  end
end
