module ForemanDatacenter
  class RackGroupsController < ForemanDatacenter::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanDatacenter::Controller::Parameters::RackGroup

    before_action :find_resource, only: [:show, :edit, :update, :destroy]

    def index
      @rack_groups = resource_base_search_and_page.includes(:site, :racks)
    end

    def show
       # just for test
      @comments = @rack_group.comments
      @commentable = @rack_group
      @comment = Comment.new
      @resource = request.path.split('/')[2]
      @current_user = current_user
    end

    def new
      @rack_group = ForemanDatacenter::RackGroup.new
    end

    def edit
    end

    def create
      @rack_group = ForemanDatacenter::RackGroup.new(rack_group_params)

      if @rack_group.save
        process_success object: @rack_group
      else
        process_error object: @rack_group
      end
    end

    def update
      if @rack_group.update(rack_group_params)
        process_success object: @rack_group
      else
        process_error object: @rack_group
      end
    end

    def destroy
      if @rack_group.destroy
        process_success success_redirect: "/datacenter/rack_groups"
      else
        process_error object: @rack_group
      end
    end
  end
end
