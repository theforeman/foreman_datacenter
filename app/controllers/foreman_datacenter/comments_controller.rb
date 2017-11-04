module ForemanDatacenter
  class CommentsController < ApplicationController
    before_filter :load_resource, :load_commentable

    def new
      @comment = Comment.new
      @parent = Comment.find(params[:parent_id])
    end

    def edit
      @comment = Comment.find(params[:id])
      @parent = @comment.parent
    end

    def create
      @comment = @commentable.comments.new(comment_params.merge(user_id: User.current.id))
      if @comment.save
        process_success :success_redirect => "/datacenter/#{@resource}/#{@id}#comment-#{@comment.id}"
      else
        process_error :redirect => "/datacenter/#{@resource}/#{@id}", :error_msg => _("Failed: %s") % (e)
      end
    end

    def update
      @comment = Comment.find(params[:id])
      @device = find_commentable(@comment)
      @submodule = parse_submodule(@comment)
      if @comment.update(comment_params.merge(user_id: User.current.id))
        process_success :success_redirect => "/datacenter/#{@submodule}/#{@comment.commentable_id}#comment-#{@comment.id}"
      else
        process_error :redirect => "/datacenter/#{@submodule}/#{@comment.commentable_id}#comment-#{@comment.id}", :error_msg => _("Failed: %s") % (e)
      end
    end

    def destroy
      @comment = ForemanDatacenter::Comment.find(params[:id])
      if @comment.destroy
        process_success :success_redirect => "/datacenter/#{@resource}/#{@id}#comment-#{@comment.id}"
      else
        process_error :redirect => "/datacenter/#{@resource}/#{@id}", :error_msg => _("Failed: %s") % (e)
      end
    end

    private

    def load_resource
      if (params[:resource] && params[:resource_id])
        @resource, @id = params[:resource], params[:resource_id]
      else
        @resource, @id = request.path.split('/')[2, 3]
      end
    end

    def load_commentable
      begin
        @commentable = "foreman_datacenter::#{@resource.capitalize}".singularize.classify.constantize.find(@id.to_i)
      rescue
        @commentable = "foreman_datacenter::#{params[:resource].capitalize}".singularize.classify.constantize.find(params[:resource_id].to_i)
      end
    end

    def comment_params
      params[:foreman_datacenter_comment].permit(:content, :commntable_type, :commentable_id, :parent_id, :user_id)
    end

    def find_commentable(comment)
      comment.commentable_type.classify.constantize.find(comment.commentable_id)
    end

    def parse_submodule(comment)
      comment.commentable_type.gsub("ForemanDatacenter::", "").pluralize.downcase
    end

  end
end

