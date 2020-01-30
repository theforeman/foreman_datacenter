require 'integration_test_helper'

module ForemanDatacenter
  class RackGroupIntegrationTest < ActionDispatch::IntegrationTest

    before do
      @rack_group = ForemanDatacenter::RackGroup.first
    end

    test "create new page" do
      assert_new_button(rack_groups_path,"Create Rack Group",new_rack_group_path)
      fill_in "rack_group_name", :with => "Room 3"
      select 'site_2', :from => "rack_group_site_id"
      assert_submit_button(rack_groups_path)
      assert page.has_link? "Room 3"
    end

    test "edit page" do
      visit rack_groups_path
      click_link "Edit", :href => "/datacenter/rack_groups/#{@rack_group.id}/edit"
      fill_in "rack_group_name", :with => "Room4"
      assert_submit_button(rack_groups_path)
      assert page.has_link? "Room4"
    end

    test "show page" do
	    visit rack_groups_path
	    click_link @rack_group.name
      assert page.has_link?("Move associated objects", :href => "/datacenter/rack_groups/#{@rack_group.id}/move")
	    assert page.has_link?("Edit", :href => "/datacenter/rack_groups/#{@rack_group.id}/edit")
	    assert page.has_link?("Delete", :href => "#")
    end

  end
end
