require 'integration_test_helper'

module ForemanDatacenter
  class DeviceTypeIntegrationTest < ActionDispatch::IntegrationTest
    before do
      @device_type = ForemanDatacenter::DeviceType.first
    end

    test 'create new page' do
      assert_new_button(device_types_path, 'Create Device Type', new_device_type_path)
      fill_in 'device_type_model', with: 'NewModel'
      select 'manufacturer_2', from: 'device_type_manufacturer_id'
      assert_submit_button(device_types_path)
      assert page.has_link? 'NewModel'
    end

    test 'edit page' do
      visit device_types_path
      click_link 'Edit', href: "/datacenter/device_types/#{@device_type.id}/edit"
      fill_in 'device_type_model', with: 'DR'
      select 'manufacturer_3', from: 'device_type_manufacturer_id'
      assert_submit_button(device_types_path)
      assert page.has_link? 'DR'
    end

    test 'show page' do
      visit device_types_path
      click_link @device_type.model
      assert page.has_link?('Edit', href: "/datacenter/device_types/#{@device_type.id}/edit")
      assert page.has_link?('Delete', href: '#')
    end
  end
end
