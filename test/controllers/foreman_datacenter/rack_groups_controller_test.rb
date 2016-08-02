require 'test_helper'

module ForemanDatacenter
  class RackGroupsControllerTest < ActionController::TestCase
    setup do
      @rack_group = foreman_datacenter_rack_groups(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:rack_groups)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create rack_group" do
      assert_difference('RackGroup.count') do
        post :create, rack_group: {  }
      end

      assert_redirected_to rack_group_path(assigns(:rack_group))
    end

    test "should show rack_group" do
      get :show, id: @rack_group
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @rack_group
      assert_response :success
    end

    test "should update rack_group" do
      patch :update, id: @rack_group, rack_group: {  }
      assert_redirected_to rack_group_path(assigns(:rack_group))
    end

    test "should destroy rack_group" do
      assert_difference('RackGroup.count', -1) do
        delete :destroy, id: @rack_group
      end

      assert_redirected_to rack_groups_path
    end
  end
end
