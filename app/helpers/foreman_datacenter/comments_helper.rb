module ForemanDatacenter
  module CommentsHelper
    def commentable_path(comment)
      resource = comment.commentable.class.to_s.gsub("ForemanDatacenter::","").pluralize.split(/(?<!\s)(?=[A-Z])/).join('_').downcase
      "/datacenter/#{resource}/#{comment.commentable.id}#comment-#{comment.id}"
    end
  end
end
