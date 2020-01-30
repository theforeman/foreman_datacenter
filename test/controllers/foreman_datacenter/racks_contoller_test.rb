require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class RacksControllerTest < ActionController::TestCase
    describe ForemanDatacenter::RacksController do
      setup do
        @model = ForemanDatacenter::Rack.first
      end

      basic_index_test 'racks'
      basic_new_test
      basic_edit_test 'rack'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_create_invalid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(false)
        post :create, params: { rack: { name: nil } }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid(name = "test rack")
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(true)
        post :create, params: { rack: { name: name } }, session: set_session_user
        assert_redirected_to racks_url
      end

      def test_update_invalid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(false)
        put :update, params: { id: @model.to_param, rack: { name: '3243' } }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(true)
        put :update, params: { id: @model.to_param, rack: { name: @model.name } }, session: set_session_user
        assert_redirected_to racks_url
      end

      def test_destroy
        test_create_valid "tobedeleted_test"
        @new_rack = ForemanDatacenter::Rack.find_by_name("tobedeleted_test")
        delete :destroy, params: { id: @new_rack.id }, session: set_session_user
        assert_redirected_to racks_url
        assert !ForemanDatacenter::Rack.exists?(@new_rack.id)
      end

      test "should not get index when not permitted" do
        setup_user
        get :index, session: { :user => users(:one).id, :expires_at => 5.minutes.from_now }
        assert_response :forbidden
        assert_includes @response.body, 'view_racks'
      end

      test 'should not get show when not permitted' do
        setup_user
        get :show, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'view_racks'
      end

      test 'should not get edit when not permitted' do
        setup_user
        get :edit, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_racks'
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
        assert_includes @response.body, 'edit_racks'
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

      test "should_render_404_when_rack_is_not_found" do
        get :show, params: { id: 'no.such.rack' }, session: set_session_user
        assert_response :not_found
        assert_template 'common/404'
      end

      test "should_not_destroy_rack_when_not_permitted" do
        setup_user
        assert_difference('ForemanDatacenter::Rack.count', 0) do
          delete :destroy, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        end
        assert_response :forbidden
      end

      test "should search by name" do
        get :index, params: {:search => "name=\"rack_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:racks)
        assert assigns(:racks).include?(racks(:one))
      end

      test "should search by rack group" do
        get :index, params: {:search => "rack_group=\"rack_group_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:racks)
        assert assigns(:racks).include?(racks(:one))
      end

      test "should search by site" do
        get :index, params: {:search => "site=\"site_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:racks)
        assert assigns(:racks).include?(racks(:one))
      end

      test "should search by facility_id" do
        get :index, params: {:search => "facility_id=\"1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:racks)
        assert assigns(:racks).include?(racks(:one))
      end

      test "should search by height" do
        get :index, params: {:search => "height=\"10\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:racks)
        assert assigns(:racks).include?(racks(:one))
      end
    end
  end
end
