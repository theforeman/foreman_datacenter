require 'integration_test_helper'

module ForemanDatacenter
  class RackIntegrationTest < ActionDispatch::IntegrationTest
    test "index page" do
      assert_index_page(racks_path,"Rack Groups","New Rack Group")
    end

    test "create new page" do
      assert_new_button(rack_groups_path,"New Rack Group",new_rack_group_path)
      fill_in "rack_group_name", :with => "Room 3"
      fill_in "rack_group_site_id", :with => 1
      assert_submit_button(rack_groups_path)
      assert page.has_link? "Room 3"
    end

    test "edit page" do
      visit rack_groups_path
      click_link "Room 3"
      fill_in "rack_group_name", :with => "Room4"
      assert_submit_button(rack_groups_path)
      assert page.has_link? "Room4"
    end
  end
end
