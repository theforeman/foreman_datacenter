require 'test_helper'

module ForemanDatacenter
  class DeviceTypesControllerTest < ActionController::TestCase
    setup do
      @device_type = foreman_datacenter_device_types(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:device_types)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create device_type" do
      assert_difference('DeviceType.count') do
        post :create, device_type: {  }
      end

      assert_redirected_to device_type_path(assigns(:device_type))
    end

    test "should show device_type" do
      get :show, id: @device_type
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @device_type
      assert_response :success
    end

    test "should update device_type" do
      patch :update, id: @device_type, device_type: {  }
      assert_redirected_to device_type_path(assigns(:device_type))
    end

    test "should destroy device_type" do
      assert_difference('DeviceType.count', -1) do
        delete :destroy, id: @device_type
      end

      assert_redirected_to device_types_path
    end
  end
end
