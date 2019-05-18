module ForemanDatacenter::Controller::Racks
  extend ActiveSupport::Concern

  def move
    @rack_groups = resource_base_search_and_page
    @racks = @rack_group.racks
    process_error object: @rack_group, error_msg: 'Current Rack Group haven\'t any Racks.' if @racks.empty?
  end

end
