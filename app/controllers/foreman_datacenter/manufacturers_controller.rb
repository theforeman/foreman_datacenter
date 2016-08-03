module ForemanDatacenter
  class ManufacturersController < ApplicationController
    before_action :set_manufacturer, only: [:show, :edit, :update, :destroy]

    def index
      @manufacturers = Manufacturer.all
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
      if @manufacturer.destroy
        process_success object: @manufacturer
      else
        process_error object: @manufacturer
      end
    end

    private

    def set_manufacturer
      @manufacturer = Manufacturer.find(params[:id])
    end

    def manufacturer_params
      params[:manufacturer].permit(:name)
    end
  end
end
