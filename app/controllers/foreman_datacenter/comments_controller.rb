module ForemanDatacenter
  class CommentsController < ApplicationController
    before_filter :load_commentable

    def index
      @comments = @commentable.comments
    end

    def new
    end

    def edit
    end

    def create
    end

    def update
    end

    def destroy
    end

    private
    def load_commentable
      resource, id = request.path.split('/')[2, 3]
      @commentable = "foreman_datacenter::#{resource.capitalize}".singularize.classify.constantize.find(id)
    end

  end
end
