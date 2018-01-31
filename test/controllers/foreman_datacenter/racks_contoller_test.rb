require 'test_helper'

module ForemanDatacenter
  class RacksControllerTest < ActionController::TestCase
    setup do
      @model = ForemanDatacenter::Rack.first
    end

    basic_index_test
    basic_new_test
    basic_edit_test
    basic_pagination_per_page_test
    basic_pagination_rendered_test

    test 'test_new_submit_button_id' do
      get :new, {}, set_session_user
      assert_select "[data-id='aid_create_foreman_datacenter_racks']"
    end

    test 'test_new_cancel_button_id' do
      get :new, {}, set_session_user
      assert_select "[data-id='aid_datacenter_racks']"
    end

    test 'test_create_invalid' do
      ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(false)
      post :create, {:rack => {:name => nil, :site => nil, :height => nil}}, set_session_user
      assert_template 'new'
    end

    test 'test_create_valid' do
      ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(true)
      post :create, {:rack => {:name => 'test rack', :height => '42', :site => Site.first.id }}, set_session_user
      assert_redirected_to racks_url
    end

    test 'test_edit_submit_button_id' do
      get :edit, {:id => ForemanDatacenter::Rack.first}, set_session_user
      assert_select "[data-id='aid_update_foreman_datacenter_rack']"
    end

    test 'test_update_invalid' do
      ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(false)
      put :update, {:id => ForemanDatacenter::Rack.first.to_param, :rack => {:name => "3243"}}, set_session_user
      assert_template 'edit'
    end

    test 'test_update_valid' do
      ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(true)
      put :update, {:id => ForemanDatacenter::Rack.first.to_param, :rack => {:name => ForemanDatacenter::Rack.first.name}}, set_session_user
      assert_redirected_to racks_url
    end

    test 'test_destroy' do
      rack = ForemanDatacenter::Rack.first
      delete :destroy, {:id => rack}, set_session_user
      assert_redirected_to racks_url
      assert !ForemanDatacenter::Rack.exists?(rack.id)
    end

    test '403 response contains missing permissions' do
      setup_user
      get :edit, { :id => ForemanDatacenter::Rack.first.id }, {:user => users(:one).id, :expires_at => 5.minutes.from_now}
      assert_response :forbidden
      assert_includes @response.body, 'edit_racks'
    end

    def setup_user
      @request.session[:user] = users(:one).id
      users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
    end

    test 'user_with_viewer_rights_should_fail_to_edit_a_rack' do
      setup_user
      get :edit, {:id => ForemanDatacenter::Rack.first.id}
      assert_response :forbidden
    end

    test 'user_with_viewer_rights_should_succeed_in_viewing_racks' do
      setup_user
      get :index
      assert_response :success
    end

    test 'user_with_viewer_rights_should_succeed_in_viewing_rack' do
      setup_user
      get :show
      assert_response :success
    end
  end
end
