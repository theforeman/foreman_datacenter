module ForemanDatacenter
  class CommentsController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::Comment

    before_action :load_resource, :load_commentable, :load_current_user
    before_action :check_owner, only: [:edit]

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
        process_success :success_redirect => "/datacenter/#{@resource}/#{@id}#comment-#{@comment.id}", success_msg: "Comment successfully created."
      else
        process_error :redirect => "/datacenter/#{@resource}/#{@id}", :error_msg => _("Failed: %s") % (e)
      end
    end

    def update
      @comment = Comment.find(params[:id])
      @device = find_commentable(@comment)
      @submodule = parse_submodule(@comment)
      if @comment.user == @current_user or @comment.user.nil?
        if @comment.update(comment_params)
          process_success :success_redirect => "/datacenter/#{@submodule}/#{@comment.commentable_id}#comment-#{@comment.id}", success_msg: "Comment successfully updated."
        else
          process_error :redirect => "/datacenter/#{@submodule}/#{@comment.commentable_id}#comment-#{@comment.id}", :error_msg => _("Failed: %s") % (e)
        end
      else
          process_error :redirect => "/datacenter/#{@submodule}/#{@comment.commentable_id}#comment-#{@comment.id}", :error_msg => _("You can edit only your own comments")
      end
    end

    def destroy
      @comment = Comment.find(params[:id])
      if @comment.user == @current_user or @comment.user.nil?
        if @comment.destroy
          process_success :success_redirect => "/datacenter/#{@resource}/#{@id}#comment-#{@comment.id}", success_msg: "Comment successfully deleted."
        else
          process_error :redirect => "/datacenter/#{@resource}/#{@id}", :error_msg => _("Failed: %s") % (e)
        end
      else
          process_error :redirect => "/datacenter/#{@resource}/#{@id}", :error_msg => _("You can delete only your own comments")
      end
    end

    private

    def load_current_user
      @current_user = User.current
    end

    def check_owner
      comment = Comment.find(params[:id])
      commentable = comment.commentable_type.constantize.find(comment.commentable_id)
      resource = parse_submodule(comment)
      unless comment.user == @current_user or comment.user.nil?
        process_error :redirect => (request.referrer || "/datacenter/#{resource}/#{commentable.id}" || root_path), :error_msg => _("You can edit only your own comments")
        return
      end
    end

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


