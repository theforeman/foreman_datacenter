module ForemanDatacenter
  class ManagementDevice < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :device, :class_name => 'ForemanDatacenter::Device'

    validates :console_url, presence: true, length: { maximum: 255 }

    scoped_search on: :login, complete_value: true, default_order: true

    def to_label
      console_url
    end
  end
end
