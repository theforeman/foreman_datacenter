module ForemanDatacenter
  class PlatformsController < ApplicationController
    before_action :set_platform, only: [:show, :edit, :update, :destroy]

    def index
      @platforms = Platform.includes(:devices).all
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
      if @platform.destroy
        process_success object: @platform
      else
        process_error object: @platform
      end
    end

    private

    def set_platform
      @platform = Platform.find(params[:id])
    end

    def platform_params
      params[:platform].permit(:name, :rpc_client)
    end
  end
end
