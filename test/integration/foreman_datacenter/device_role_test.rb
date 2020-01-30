require 'integration_test_helper'

module ForemanDatacenter
  class DeviceRoleIntegrationTest < ActionDispatch::IntegrationTest
    
    before do
    	@device_role = ForemanDatacenter::DeviceRole.first
    end

    test "create new page" do
      assert_new_button(device_roles_path,"Create Device Role",new_device_role_path)
      fill_in "device_role_name", :with => "NewDR"
      select 'Green', :from => "device_role_color"
      assert_submit_button(device_roles_path)
      assert page.has_link? "NewDR"
    end

    test "edit page" do
      visit device_roles_path
      click_link "Edit", :href => "/datacenter/device_roles/#{@device_role.id}/edit"
      fill_in "device_role_name", :with => "DR"
      select 'Red', :from => "device_role_color"
      assert_submit_button(device_roles_path)
      assert page.has_link? "DR"
    end

  	test "show page" do
	    visit device_roles_path
	    click_link @device_role.name
	    assert page.has_link?("Edit", :href => "/datacenter/device_roles/#{@device_role.id}/edit")
	    assert page.has_link?("Delete", :href => "#")
  	end

  end
end