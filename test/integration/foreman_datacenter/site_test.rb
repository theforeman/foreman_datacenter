require 'integration_test_helper'

module ForemanDatacenter
  class SiteIntegrationTest < ActionDispatch::IntegrationTest

    before do
      @site = ForemanDatacenter::Site.first
    end

    test "create new page" do
      assert_new_button(sites_path,"Create Site",new_site_path)
      fill_in "site_name", :with => "Site1"
      fill_in "site_facility", :with => "test facility"
      fill_in "site_asn", :with => 1
      fill_in "site_physical_address", :with => "physical address"
      fill_in "site_shipping_address", :with => "shipping address"
      fill_in "site_comments", :with => "comments"
      assert_submit_button(sites_path)
      assert page.has_link? 'Site1'
    end

    test "edit page" do
      visit sites_path
      click_link "Edit", :href => "/datacenter/sites/#{@site.id}/edit"
      fill_in "site_name", :with => "DC 1"
      assert_submit_button(sites_path)
      assert page.has_link? 'DC 1'
    end

    test "show page" do
      visit sites_path
      click_link @site.name
      assert page.has_link?("Move associated objects", :href => "/datacenter/sites/#{@site.id}/move")
      assert page.has_link?("Edit", :href => "/datacenter/sites/#{@site.id}/edit")
      assert page.has_link?("Delete", :href => "#")
    end

  end
end