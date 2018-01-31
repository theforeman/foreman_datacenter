require 'test_helper'

module ForemanDatacenter
  class SitesControllerTest < ActionController::TestCase
    setup do
      @model = ForemanDatacenter::Site.first
    end

    basic_index_test
    basic_new_test
    basic_edit_test
    basic_pagination_per_page_test
    basic_pagination_rendered_test

    test 'test_new_submit_button_id' do
      get :new, {}, set_session_user
      assert_select "[data-id='aid_create_foreman_datacenter_sites']"
    end

    test 'test_new_cancel_button_id' do
      get :new, {}, set_session_user
      assert_select "[data-id='aid_datacenter_sites']"
    end

    test 'test_create_invalid' do
      ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(false)
      post :create, {:site => {:name => nil}}, set_session_user
      assert_template 'new'
    end

    test 'test_create_valid' do
      ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(true)
      post :create, {:site => {:name => 'test site'}}, set_session_user
      assert_redirected_to sites_url
    end

    test 'test_edit_submit_button_id' do
      get :edit, {:id => ForemanDatacenter::Site.first}, set_session_user
      assert_select "[data-id='aid_update_foreman_datacenter_site']"
    end

    test 'test_update_invalid' do
      ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(false)
      put :update, {:id => ForemanDatacenter::Site.first.to_param, :site => {:name => "3243", :asn => "string"}}, set_session_user
      assert_template 'edit'
    end

    test 'test_update_valid' do
      ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(true)
      put :update, {:id => ForemanDatacenter::Site.first.to_param, :site => {:name => ForemanDatacenter::Site.first.name}}, set_session_user
      assert_redirected_to sites_url
    end

    test 'test_destroy' do
      site = ForemanDatacenter::Site.first
      delete :destroy, {:id => site}, set_session_user
      assert_redirected_to sites_url
      assert !ForemanDatacenter::Site.exists?(site.id)
    end

    test '403 response contains missing permissions' do
      setup_user
      get :edit, { :id => ForemanDatacenter::Site.first.id }, {:user => users(:one).id, :expires_at => 5.minutes.from_now}
      assert_response :forbidden
      assert_includes @response.body, 'edit_sites'
    end

    def setup_user
      @request.session[:user] = users(:one).id
      users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
    end

    test 'user_with_viewer_rights_should_fail_to_edit_a_site' do
      setup_user
      get :edit, {:id => ForemanDatacenter::Site.first.id}
      assert_response :forbidden
    end

    test 'user_with_viewer_rights_should_succeed_in_viewing_sites' do
      setup_user
      get :index
      assert_response :success
    end

    test 'user_with_viewer_rights_should_succeed_in_viewing_site' do
      setup_user
      get :show
      assert_response :success
    end
  end
end
