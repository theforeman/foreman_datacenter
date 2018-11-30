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

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_device_types']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_device_types']"
      end
      
      def test_show_edit_button_id
        get :show, params: { :id => ForemanDatacenter::DeviceType.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_device_types_#{ForemanDatacenter::DeviceType.first.id}_edit']"
      end

      def test_show_delete_button_id
        get :show, params: { :id => ForemanDatacenter::DeviceType.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_datacenter_device_types_#{ForemanDatacenter::DeviceType.first.id}']"
      end

      test "should_show_device_type" do
        setup_user
        get :show, params: { :id => ForemanDatacenter::DeviceType.first.to_param }, session: set_session_user
        assert_response :success
      end

      def test_create_invalid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :device_type => {:model => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :device_type => {:model => 'test model'} }, session: set_session_user
        # assert_redirected_to device_types_url
        # assert_redirected_to device_type_url(ForemanDatacenter::DeviceType.first)
      end

      def test_edit_submit_button_id
        get :edit, params: { :id => ForemanDatacenter::DeviceType.first }, session: set_session_user
        assert_select "[data-id='aid_update_foreman_datacenter_device_type']"
      end

      def test_update_invalid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => ForemanDatacenter::DeviceType.first.to_param, :device_type => {:model => "3243"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::DeviceType.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => ForemanDatacenter::DeviceType.first.to_param, :device_type => {:model => ForemanDatacenter::DeviceType.first.model} }, session: set_session_user
        # assert_redirected_to device_type_url(ForemanDatacenter::DeviceType.first)
      end

      def test_destroy
        device_type = ForemanDatacenter::DeviceType.first
        # architecture.hosts.delete_all
        # architecture.hostgroups.delete_all
        delete :destroy, params: { :id => device_type.id }, session: set_session_user
        assert_redirected_to device_types_url
        assert !ForemanDatacenter::DeviceType.exists?(device_type.id)
      end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      def get_factory_name
        :device_type
      end
    end
  end
end
