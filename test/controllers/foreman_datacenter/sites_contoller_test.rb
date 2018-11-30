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

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_sites']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_sites']"
      end
      
      def test_show_edit_button_id
        get :show, params: { :id => ForemanDatacenter::Site.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_sites_#{ForemanDatacenter::Site.first.id}_edit']"
      end

      def test_show_delete_button_id
        get :show, params: { :id => ForemanDatacenter::Site.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_datacenter_sites_#{ForemanDatacenter::Site.first.id}']"
      end

      test "should_show_site" do
        setup_user
        get :show, params: { :id => ForemanDatacenter::Site.first.to_param }, session: set_session_user
        assert_response :success
      end

      def test_create_invalid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :site => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :site => {:name => 'test site'} }, session: set_session_user
        assert_redirected_to sites_url
      end

      def test_edit_submit_button_id
        get :edit, params: { :id => ForemanDatacenter::Site.first }, session: set_session_user
        assert_select "[data-id='aid_update_foreman_datacenter_site']"
      end

      def test_update_invalid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => ForemanDatacenter::Site.first.to_param, :site => {:name => "3243", :asn => "string"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Site.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => ForemanDatacenter::Site.first.to_param, :site => {:name => ForemanDatacenter::Site.first.name} }, session: set_session_user
        assert_redirected_to sites_url
      end

      # def test_destroy
      #   site = ForemanDatacenter::Site.first
      #   # architecture.hosts.delete_all
      #   # architecture.hostgroups.delete_all
      #   delete :destroy, params: { :id => site }, session: set_session_user
      #   assert_redirected_to sites_url
      #   assert !ForemanDatacenter::Site.exists?(site.id)
      # end

      test '403 response contains missing permissions' do
        setup_user
        get :edit, params: { :id => ForemanDatacenter::Site.first.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_sites'
      end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      # TODO Not executed
      # Expected response to be a <403: forbidden>, but was a <302: Found> redirect to <http://test.host/users/login>
      # test "user with viewer rights should fail to edit a site" do
      #   setup_user
      #   get :edit, params: {:id => ForemanDatacenter::Site.first.id}
      #   assert_response :forbidden
      # end

      # TODO
      # Expected response to be a <403: forbidden>, but was a <302: Found> redirect to <http://test.host/users/login>
      # test "user_with_viewer_rights_should_succeed_in_viewing_sites" do
      #   setup_user
      #   get :index
      #   assert_response :success
      # end

      # TODO
      # test "should not show site when not permitted" do
      #   setup_user "none"
      #   get :show, params: { :id => ForemanDatacenter::Site.first.to_param }#, session: set_session_user
      #   assert_response 403
      # end

      # TODO
      # test "should not show site when restricted" do
      #   setup_user "view"
      #   get :show, params: { :id => @your_site.to_param }, session: set_session_user
      #   assert_response 404
      # end

      def get_factory_name
        :site
      end
    end
  end
end
