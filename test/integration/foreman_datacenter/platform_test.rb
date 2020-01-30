require 'integration_test_helper'

module ForemanDatacenter
  class PlatformIntegrationTest < ActionDispatch::IntegrationTest
    
    before do
    	@platform = ForemanDatacenter::Platform.first
    end

    test "create new page" do
      assert_new_button(platforms_path,"Create Platform",new_platform_path)
      fill_in "platform_name", :with => "New Platform"
      select "Juniper Junos (NETCONF)", :from => "platform_rpc_client"
      assert_submit_button(platforms_path)
      assert page.has_link? "New Platform"
    end

    test "edit page" do
      visit platforms_path
      click_link "Edit", :href => "/datacenter/platforms/#{@platform.id}/edit"
      fill_in "platform_name", :with => "Another Platform"
      select "Opengear (SSH)", :from => "platform_rpc_client"
      assert_submit_button(platforms_path)
      assert page.has_link? "Another Platform"
    end

  	test "show page" do
	    visit platforms_path
	    click_link @platform.name
	    assert page.has_link?("Edit", :href => "/datacenter/platforms/#{@platform.id}/edit")
	    assert page.has_link?("Delete", :href => "#")
  	end

  end
end
