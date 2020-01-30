require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class SitesControllerTest < ActionController::TestCase
    describe ForemanDatacenter::SitesController do
      setup do
        @model = ForemanDatacenter::Site.first
      end

      basic_index_test 'sites'
      basic_new_test
      basic_edit_test 'site'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_create_invalid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :site => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid(name = "test site")
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :site => {:name => name} }, session: set_session_user
        assert_redirected_to sites_url
      end

      def test_update_invalid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => @model.to_param, :site => {:name => "", :asn => "string"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => @model.to_param, :site => {:name => @model.name} }, session: set_session_user
        assert_redirected_to sites_url
      end

      def test_destroy
        test_create_valid "tobedeleted_test"
        @new_site = ForemanDatacenter::Site.find_by_name("tobedeleted_test")
        delete :destroy, params: { :id => @new_site.id }, session: set_session_user
        assert_redirected_to sites_url
        assert !ForemanDatacenter::Site.exists?(@new_site.id)
      end

      test "should not get index when not permitted" do
        setup_user
        get :index, session: { :user => users(:one).id, :expires_at => 5.minutes.from_now }
        assert_response :forbidden
        assert_includes @response.body, 'view_sites'
      end

      test 'should not get show when not permitted' do
        setup_user
        get :show, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'view_sites'
      end

      test 'should not get edit when not permitted' do
        setup_user
        get :edit, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_sites'
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
        assert_includes @response.body, 'edit_sites'
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

      test "should search by name" do
        get :index, params: {:search => "name=\"site_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:sites)
        assert assigns(:sites).include?(sites(:one))
      end

      test "should search by facility" do
        get :index, params: {:search => "facility=\"facility_for_site_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:sites)
        assert assigns(:sites).include?(sites(:one))
      end

      test "should search by physical_address" do
        get :index, params: {:search => "physical_address=\"phisycal_address_for_site_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:sites)
        assert assigns(:sites).include?(sites(:one))
      end

      test "should search by shipping_address" do
        get :index, params: {:search => "shipping_address=\"shipping_address_for_site_1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:sites)
        assert assigns(:sites).include?(sites(:one))
      end

      test "should search by asn" do
        get :index, params: {:search => "asn=\"1\""}, session: set_session_user
        assert_response :success
        refute_empty assigns(:sites)
        assert assigns(:sites).include?(sites(:one))
      end

      test "should_render_404_when_site_is_not_found" do
        get :show, params: { id: 'no.such.site' }, session: set_session_user
        assert_response :not_found
        assert_template 'common/404'
      end

      test "should_not_destroy_site_when_not_permitted" do
        setup_user
        assert_difference('ForemanDatacenter::Site.count', 0) do
          delete :destroy, params: { :id => @model.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        end
        assert_response :forbidden
      end

    end
  end
end
