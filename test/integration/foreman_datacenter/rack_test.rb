require 'integration_test_helper'

module ForemanDatacenter
  class RackIntegrationTest < ActionDispatch::IntegrationTest

    before do
      @rack = ForemanDatacenter::Rack.first
    end

    test "create new page" do
      assert_new_button(racks_path,"Create Rack",new_rack_path)
      select 'site_2', :from => "rack_site_id"
      fill_in "rack_name", :with => "New Rack"
      fill_in "rack_facility_id", :with => "1234"
      fill_in "rack_height", :with => "10"
      assert_submit_button(racks_path)
      assert page.has_link? "New Rack"
    end

    test "edit page" do
      visit racks_path
      click_link "Edit", :href => "/datacenter/racks/#{@rack.id}/edit"
      fill_in "rack_name", :with => "another_rack_1"
      assert_submit_button(racks_path)
      assert page.has_link? "another_rack_1"
    end

    test "show page" do
      visit racks_path
      click_link @rack.name
      assert page.has_link?("Move associated objects", :href => "/datacenter/racks/#{@rack.id}/move")
      assert page.has_link?("Edit", :href => "/datacenter/racks/#{@rack.id}/edit")
      assert page.has_link?("Delete", :href => "#")
    end

  end
end
