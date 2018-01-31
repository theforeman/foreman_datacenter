require 'test_helper'

module ForemanDatacenter
  class RackGroupsControllerTest < ActionController::TestCase
    setup do
      @model = RackGroup.first
    end

    basic_index_test
    basic_new_test
    basic_edit_test
    basic_pagination_per_page_test
    basic_pagination_rendered_test

    test 'test_new_submit_button_id' do
      get :new, {}, set_session_user
      assert_select "[data-id='aid_create_foreman_datacenter_rack_group']"
    end

    test 'test_new_cancel_button_id' do
      get :new, {}, set_session_user
      assert_select "[data-id='aid_datacenter_rack_groups']"
    end

    test 'test_create_invalid' do
      RackGroup.any_instance.stubs(:valid?).returns(false)
      post :create, {:rack_group => {:name => nil, :site_id => nil}}, set_session_user
      assert_template 'new'
    end

    test 'test_create_valid' do
      RackGroup.any_instance.stubs(:valid?).returns(true)
      post :create, {:rack_group => {:name => 'test rack_group', :site_id => Site.first.id}}, set_session_user
      assert_redirected_to rack_groups_url
    end

    test 'test_edit_submit_button_id' do
      get :edit, {:id => RackGroup.first}, set_session_user
      assert_select "[data-id='aid_update_foreman_datacenter_rack_group']"
    end

    test 'test_update_invalid' do
      RackGroup.any_instance.stubs(:valid?).returns(false)
      put :update, {:id => RackGroup.first.to_param, :rack_group => {:name => "3243"}}, set_session_user
      assert_template 'edit'
    end

    test 'test_update_valid' do
      Site.any_instance.stubs(:valid?).returns(true)
      put :update, {:id => RackGroup.first.to_param, :rack_group => {:name => RackGroup.first.name}}, set_session_user
      assert_redirected_to rack_groups_url
    end

    test 'test_destroy' do
      rack_group = RackGroup.first
      delete :destroy, {:id => rack_group}, set_session_user
      assert_redirected_to rack_groups_url
      assert !RackGroup.exists?(rack_group.id)
    end

    test '403 response contains missing permissions' do
      setup_user
      get :edit, { :id => RackGroup.first.id }, {:user => users(:one).id, :expires_at => 5.minutes.from_now}
      assert_response :forbidden
      assert_includes @response.body, 'edit_rack_groups'
    end

    def setup_user
      @request.session[:user] = users(:one).id
      users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
    end

    test 'user_with_viewer_rights_should_fail_to_edit_a_rack_group' do
      setup_user
      get :edit, {:id => RackGroup.first.id}
      assert_response :forbidden
    end

    test 'user_with_viewer_rights_should_succeed_in_viewing_rack_groups' do
      setup_user
      get :index
      assert_response :success
    end

    test 'user_with_viewer_rights_should_succeed_in_viewing_rack_group' do
      setup_user
      get :show
      assert_response :success
    end
  end
end
