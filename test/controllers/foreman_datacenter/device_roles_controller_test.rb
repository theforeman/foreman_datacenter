require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class DeviceRolesControllerTest < ActionController::TestCase
    describe ForemanDatacenter::DeviceRolesController do
      setup do
        @model = ForemanDatacenter::DeviceRole.first
      end

      basic_index_test 'device_roles'
      basic_new_test
      basic_edit_test 'device_role'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_create_invalid
        ForemanDatacenter::DeviceRole.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :device_role => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid(name = "test device_role")
        ForemanDatacenter::DeviceRole.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :device_role => {:name => name, :color => 'Teal'} }, session: set_session_user
        assert_redirected_to device_roles_url
      end

      def test_update_invalid
        ForemanDatacenter::DeviceRole.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => @model.to_param, :device_role => {:name => "3243", :color => "Red"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::DeviceRole.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => @model.to_param, :device_role => {:name => @model.name, :color => "Green"} }, session: set_session_user
        assert_redirected_to device_roles_url
      end

      def test_destroy
        test_create_valid "tobedeleted_test"
        @new_dr = ForemanDatacenter::DeviceRole.find_by_name("tobedeleted_test")
        delete :destroy, params: { :id => @new_dr.id }, session: set_session_user
        assert_redirected_to device_roles_url
        assert !ForemanDatacenter::DeviceRole.exists?(@new_dr.id)
      end

      test "should not get index when not permitted" do
        setup_user
        get :index, session: { :user => users(:one).id, :expires_at => 5.minutes.from_now }
        assert_response :forbidden
        assert_includes @response.body, 'view_device_roles'
      end

      test 'should not get show when not permitted' do
        setup_user
        get :show, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'view_device_roles'
      end

      test 'should not get edit when not permitted' do
        setup_user
        get :edit, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_device_roles'
      end

      test "should get index" do
        setup_user("Viewer")
        get :index, session: set_session_user
        assert_response :success
        assert_template 'index'
      end

      test 'should get show' do
        setup_user("Viewer")
        get :show, params: { :id => @model.id }, session: set_session_user
        assert_response :success
        assert_template 'show'
      end

      test 'should not get edit with viewer permissions' do
        setup_user("Viewer")
        get :edit, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_device_roles'
      end

     test 'should get edit' do
        get :edit, params: { :id => @model.id }, session: set_session_user
        assert_response :success
        assert_template 'edit'
      end

      def setup_user(role = "")
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default]
        users(:one).roles << Role.find_by_name(role) if role != ""
        # users(:one).roles       = [Role.default, Role.find_by_name("Viewer")]
      end

      test "should_render_404_when_device_role_is_not_found" do
        get :show, params: { id: 'no.such.device.role' }, session: set_session_user
        assert_response :not_found
        assert_template 'common/404'
      end

      test "should_not_destroy_device_role_when_not_permitted" do
        setup_user
        assert_difference('ForemanDatacenter::DeviceRole.count', 0) do
          delete :destroy, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        end
        assert_response :forbidden
      end

      test "should search by name" do
        get :index, params: {:search => "name=\"device_role_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:device_roles)
        assert assigns(:device_roles).include?(device_roles(:one)) 
      end

     test "should search by color" do
        get :index, params: {:search => "color=\"Teal\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:device_roles)
        assert assigns(:device_roles).include?(device_roles(:one)) 
      end
   
    end
  end
end
