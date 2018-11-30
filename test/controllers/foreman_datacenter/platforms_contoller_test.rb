require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class PlatformsControllerTest < ActionController::TestCase
    describe ForemanDatacenter::PlatformsController do
      setup do
        @model = ForemanDatacenter::Platform.first
      end

      basic_index_test 'platforms'
      basic_new_test
      basic_edit_test 'platform'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_platforms']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_platforms']"
      end
      
      def test_show_edit_button_id
        get :show, params: { :id => ForemanDatacenter::Platform.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_platforms_#{ForemanDatacenter::Platform.first.id}_edit']"
      end

      def test_show_delete_button_id
        get :show, params: { :id => ForemanDatacenter::Platform.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_datacenter_platforms_#{ForemanDatacenter::Platform.first.id}']"
      end

      test "should_show_platform" do
        setup_user
        get :show, params: { :id => ForemanDatacenter::Platform.first.to_param }, session: set_session_user
        assert_response :success
      end

      def test_create_invalid
        ForemanDatacenter::Platform.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :platform => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::Platform.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :platform => {:name => 'test site'} }, session: set_session_user
        assert_redirected_to platforms_url
      end

      def test_edit_submit_button_id
        get :edit, params: { :id => ForemanDatacenter::Platform.first }, session: set_session_user
        assert_select "[data-id='aid_update_foreman_datacenter_platform']"
      end

      def test_update_invalid
        ForemanDatacenter::Platform.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => ForemanDatacenter::Platform.first.to_param, :platform => {:name => "3243", :asn => "string"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Platform.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => ForemanDatacenter::Platform.first.to_param, :platform => {:name => ForemanDatacenter::Site.first.name} }, session: set_session_user
        assert_redirected_to platforms_url
      end

      # def test_destroy
      #   platform = ForemanDatacenter::Platform.first
      #   # architecture.hosts.delete_all
      #   # architecture.hostgroups.delete_all
      #   delete :destroy, params: { :id => platform }, session: set_session_user
      #   assert_redirected_to platforms_url
      #   assert !ForemanDatacenter::Platform.exists?(platform.id)
      # end

      test '403 response contains missing permissions' do
        setup_user
        get :edit, params: { :id => ForemanDatacenter::Platform.first.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_platforms'
      end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      def get_factory_name
        :platform
      end
    end
  end
end
