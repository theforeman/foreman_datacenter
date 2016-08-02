module ForemanDatacenter
  module RacksHelper
    def rack_groups_for_select(rack)
      collection = rack.site ? rack.site.rack_groups : []
      options_from_collection_for_select(collection, 'id', 'name', rack.rack_group_id)
    end
  end
end
