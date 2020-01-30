require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class ManufacturersControllerTest < ActionController::TestCase
    describe ForemanDatacenter::ManufacturersController do
      setup do
        @model = ForemanDatacenter::Manufacturer.first
      end

      basic_index_test 'manufacturers'
      basic_new_test
      basic_edit_test 'manufacturer'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_create_invalid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :manufacturer => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid(name = "test manufacturer")
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :manufacturer => {:name => name} }, session: set_session_user
        assert_redirected_to manufacturers_url
      end

      def test_update_invalid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => @model.to_param, :manufacturer => {:name => "3243"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => @model.to_param, :manufacturer => {:name => @model.name} }, session: set_session_user
        assert_redirected_to manufacturers_url
      end

      def test_destroy
        test_create_valid "tobedeleted_test"
        @new_manufacturer = ForemanDatacenter::Manufacturer.find_by_name("tobedeleted_test")
        delete :destroy, params: { :id => @new_manufacturer.id }, session: set_session_user
        assert_redirected_to manufacturers_url
        assert !ForemanDatacenter::Manufacturer.exists?(@new_manufacturer.id)
      end

      def test_destroy
        test_create_valid "tobedeleted_test"
        @new_manufacturer = ForemanDatacenter::Manufacturer.find_by_name("tobedeleted_test")
        delete :destroy, params: { :id => @new_manufacturer.id }, session: set_session_user
        assert_redirected_to manufacturers_url
        assert !ForemanDatacenter::Manufacturer.exists?(@new_manufacturer.id)
      end

      test "should not get index when not permitted" do
        setup_user
        get :index, session: { :user => users(:one).id, :expires_at => 5.minutes.from_now }
        assert_response :forbidden
        assert_includes @response.body, 'view_manufacturers'
      end

      test 'should not get show when not permitted' do
        setup_user
        get :show, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'view_manufacturers'
      end

      test 'should not get edit when not permitted' do
        setup_user
        get :edit, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_manufacturers'
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
        assert_includes @response.body, 'edit_manufacturers'
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

      test "should_render_404_when_manufacturer_is_not_found" do
        get :show, params: { id: 'no.such.manufacturer' }, session: set_session_user
        assert_response :not_found
        assert_template 'common/404'
      end

      test "should_not_destroy_manufacturer_when_not_permitted" do
        setup_user
        assert_difference('ForemanDatacenter::Manufacturer.count', 0) do
          delete :destroy, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        end
        assert_response :forbidden
      end

      test "should search by name" do
        get :index, params: {:search => "name=\"manufacturer_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:manufacturers)
        assert assigns(:manufacturers).include?(manufacturers(:one)) 
      end
    end
  end
end
