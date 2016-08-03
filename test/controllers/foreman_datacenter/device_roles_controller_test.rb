require 'test_helper'

module ForemanDatacenter
  class DeviceRolesControllerTest < ActionController::TestCase
    setup do
      @device_role = foreman_datacenter_device_roles(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:device_roles)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create device_role" do
      assert_difference('DeviceRole.count') do
        post :create, device_role: {  }
      end

      assert_redirected_to device_role_path(assigns(:device_role))
    end

    test "should show device_role" do
      get :show, id: @device_role
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @device_role
      assert_response :success
    end

    test "should update device_role" do
      patch :update, id: @device_role, device_role: {  }
      assert_redirected_to device_role_path(assigns(:device_role))
    end

    test "should destroy device_role" do
      assert_difference('DeviceRole.count', -1) do
        delete :destroy, id: @device_role
      end

      assert_redirected_to device_roles_path
    end
  end
end
