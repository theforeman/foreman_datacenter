require 'integration_test_helper'

module ForemanDatacenter
  class ManufacturerIntegrationTest < ActionDispatch::IntegrationTest
    
    before do
    	@manufacturer = ForemanDatacenter::Manufacturer.first
    end

    test "create new page" do
      assert_new_button(manufacturers_path,"Create Manufacturer",new_manufacturer_path)
      fill_in "manufacturer_name", :with => "New manufacturer"
      assert_submit_button(manufacturers_path)
      assert page.has_link? "New manufacturer"
    end

    test "edit page" do
      visit manufacturers_path
      click_link "Edit", :href => "/datacenter/manufacturers/#{@manufacturer.id}/edit"
      fill_in "manufacturer_name", :with => "Another manufacturer"
      assert_submit_button(manufacturers_path)
      assert page.has_link? "Another manufacturer"
    end

    test "show page" do
	    visit manufacturers_path
	    click_link @manufacturer.name
	    assert page.has_link?("Edit", :href => "/datacenter/manufacturers/#{@manufacturer.id}/edit")
	    assert page.has_link?("Delete", :href => "#")
  	end

  end
end
