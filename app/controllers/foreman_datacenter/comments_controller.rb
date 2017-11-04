module ForemanDatacenter
  class CommentsController < ApplicationController
    before_filter :load_resource, :load_commentable

    def edit
      @comment = Comment.find(params[:id])
    end

    def create
      @comment = @commentable.comments.new(comment_params)
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
      if @comment.update(comment_params)
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
      @resource, @id = request.path.split('/')[2, 3]
    end

    def load_commentable
      @commentable = "foreman_datacenter::#{@resource.capitalize}".singularize.classify.constantize.find(@id.to_i)
    end

    def comment_params
      params[:foreman_datacenter_comment].permit(:content, :commntable_type, :commentable_id)
    end

    def find_commentable(comment)
      comment.commentable_type.classify.constantize.find(comment.commentable_id)
    end

    def parse_submodule(comment)
      comment.commentable_type.gsub("ForemanDatacenter::", "").pluralize.downcase
    end

  end
end

