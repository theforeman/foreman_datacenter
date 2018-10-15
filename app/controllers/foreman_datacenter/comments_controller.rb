module ForemanDatacenter
  class CommentsController < ForemanDatacenter::ApplicationController
    include ForemanDatacenter::Controller::Parameters::Comment

    before_action :load_resource, only: [:create]

    def new
      @comment = ForemanDatacenter::Comment.new
      @parent = ForemanDatacenter::Comment.find(params[:parent_id])
      @resource_class = @parent.commentable_type.gsub("ForemanDatacenter::","")
      @resource = @resource_class.pluralize.split(/(?<!\s)(?=[A-Z])/).join('_').downcase
      @commentable = load_resource(@resource, @parent.commentable_id)
    end

    def edit
      @comment = ForemanDatacenter::Comment.find(params[:id])
      @parent = @comment.parent
      @resource_class = @comment.commentable_type.split("::")[1]
      @current_user = current_user
    end

    def create
      @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))
      if @comment.save
        process_success success_redirect: commentable_path(@comment),
                        success_msg: "Comment successfully created."
      else
        process_error redirect: "/datacenter/#{@resource}/#{@id}", :error_msg => _("Failed: %s") % (e)
      end
    end

    def update
      @comment = ForemanDatacenter::Comment.find(params[:id])
      @resource = @comment.commentable_type.split("::")[1]
      if @comment.user == current_user or @comment.user.nil? or current_user.admin?
        if @comment.update(comment_params.merge(user_id: current_user.id))
          process_success :success_redirect => commentable_path(@comment), success_msg: "Comment successfully updated."
        else
          process_error :redirect => commentable_path(@comment), :error_msg => _("Failed: %s") % (e)
        end
      else
          process_error :redirect => commentable_path(@comment), :error_msg => _("You can edit only your own comments")
      end
    end

    def destroy
      @comment = ForemanDatacenter::Comment.find(params[:id])
      if @comment.user == current_user or @comment.user.nil? or current_user.admin?
        if @comment.destroy
          process_success :success_redirect => commentable_path(@comment, true), success_msg: "Comment successfully deleted."
        else
          process_error :redirect => commentable_path(@comment, true), :error_msg => _("Failed: %s") % (e)
        end
      else
          process_error :redirect => commentable_path(@comment, true), :error_msg => _("You can delete only your own comments")
      end
    end

    private

    def commentable_path(comment, r = false)
      resource = comment.commentable.class.to_s.gsub("ForemanDatacenter::","").pluralize.split(/(?<!\s)(?=[A-Z])/).join('_').downcase
      if r == false
        return "/datacenter/#{resource}/#{comment.commentable.id}#comment-#{comment.id}"
      else
        return "/datacenter/#{resource}/#{comment.commentable.id}"
      end
    end

    def load_commentable
      abort @comment.inspect
    end

    def load_resource(resource = nil, id = nil)
      if resource.nil?
        @resource, @id = request.path.split('/')[2, 3] if resource.nil?
        @commentable = "foreman_datacenter::#{@resource.capitalize}".singularize.classify.constantize.find(@id.to_i)
      else
        @commentable = "foreman_datacenter::#{resource.capitalize}".singularize.classify.constantize.find(id.to_i)
      end
    end

    def comment_params
      params[:foreman_datacenter_comment].permit(:content, :commntable_type, :commentable_id, :parent_id, :user_id)
    end
  end
end


