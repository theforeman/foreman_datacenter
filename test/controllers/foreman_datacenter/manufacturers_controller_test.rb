require 'test_helper'

module ForemanDatacenter
  class ManufacturersControllerTest < ActionController::TestCase
    setup do
      @manufacturer = foreman_datacenter_manufacturers(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:manufacturers)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create manufacturer" do
      assert_difference('Manufacturer.count') do
        post :create, manufacturer: {  }
      end

      assert_redirected_to manufacturer_path(assigns(:manufacturer))
    end

    test "should show manufacturer" do
      get :show, id: @manufacturer
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @manufacturer
      assert_response :success
    end

    test "should update manufacturer" do
      patch :update, id: @manufacturer, manufacturer: {  }
      assert_redirected_to manufacturer_path(assigns(:manufacturer))
    end

    test "should destroy manufacturer" do
      assert_difference('Manufacturer.count', -1) do
        delete :destroy, id: @manufacturer
      end

      assert_redirected_to manufacturers_path
    end
  end
end
