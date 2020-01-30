require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class DeviceTypesControllerTest < ActionController::TestCase
    describe ForemanDatacenter::DeviceTypesController do
      setup do
        @model = ForemanDatacenter::DeviceType.first
      end

      basic_index_test 'device_types'
      basic_new_test
      basic_edit_test 'device_type'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_create_invalid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(false)
        post :create, params: { device_type: { model: nil } }, session: set_session_user
        assert_template 'new'
         end

      def test_create_valid(model = "test device_type")
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(true)
        post :create, params: { device_type: { model: model, manufacturer_id: 1 } }, session: set_session_user
        assert_redirected_to device_types_url
      end

      def test_update_invalid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(false)
        put :update, params: { id: @model.to_param, device_type: { model: '3243', color: 'Red' } }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(true)
        put :update, params: { id: @model.to_param, device_type: { model: @model.model, color: 'Green' } }, session: set_session_user
        assert_redirected_to device_types_url
      end

      def test_create_invalid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(false)
        post :create, params: { device_type: { model: nil } }, session: set_session_user
        assert_template 'new'
      end

      def test_destroy
        test_create_valid "tobedeleted_test"
        @new_dt = ForemanDatacenter::DeviceType.find_by_model("tobedeleted_test")
        delete :destroy, params: { id: @new_dt.id }, session: set_session_user
        assert_redirected_to device_types_url
        assert !ForemanDatacenter::DeviceType.exists?(@new_dt.id)
      end

      test "should not get index when not permitted" do
        setup_user
        get :index, session: { :user => users(:one).id, :expires_at => 5.minutes.from_now }
        assert_response :forbidden
        assert_includes @response.body, 'view_device_types'
      end

      test 'should not get show when not permitted' do
        setup_user
        get :show, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'view_device_types'
      end

      test 'should not get edit when not permitted' do
        setup_user
        get :edit, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_device_types'
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
        assert_includes @response.body, 'edit_device_types'
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

      test "should_render_404_when_device_type_is_not_found" do
        get :show, params: { id: 'no.such.device.type' }, session: set_session_user
        assert_response :not_found
        assert_template 'common/404'
      end

      test "should_not_destroy_device_type_when_not_permitted" do
        setup_user
        assert_difference('ForemanDatacenter::DeviceType.count', 0) do
          delete :destroy, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        end
        assert_response :forbidden
      end

      test "should search by model" do
        get :index, params: {:search => "model=\"DeviceType_1NONE\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:device_types)
        assert assigns(:device_types).include?(device_types(:one))
      end

      test "should search by manufacturer" do
        get :index, params: {:search => "manufacturer=\"manufacturer_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:device_types)
        assert assigns(:device_types).include?(device_types(:one))
      end

      test "should search by subdevice role" do
        get :index, params: {:search => "subdevice_role=\"None\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:device_types)
        assert assigns(:device_types).include?(device_types(:one))
      end

      test "should search by U height" do
        get :index, params: {:search => "u_height=\"1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:device_types)
        assert assigns(:device_types).include?(device_types(:one))
      end
    end
  end
end
