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

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_manufacturers']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_manufacturers']"
      end
      
      def test_show_edit_button_id
        get :show, params: { :id => ForemanDatacenter::Manufacturer.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_manufacturers_#{ForemanDatacenter::Manufacturer.first.id}_edit']"
      end

      def test_show_delete_button_id
        get :show, params: { :id => ForemanDatacenter::Manufacturer.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_datacenter_manufacturers_#{ForemanDatacenter::Manufacturer.first.id}']"
      end

      test "should_show_manufacturer" do
        setup_user
        get :show, params: { :id => ForemanDatacenter::Manufacturer.first.to_param }, session: set_session_user
        assert_response :success
      end

      def test_create_invalid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :manufacturer => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :manufacturer => {:name => 'test manufacturer'} }, session: set_session_user
        assert_redirected_to manufacturers_url
      end

      def test_edit_submit_button_id
        get :edit, params: { :id => ForemanDatacenter::Manufacturer.first }, session: set_session_user
        assert_select "[data-id='aid_update_foreman_datacenter_manufacturer']"
      end

      def test_update_invalid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => ForemanDatacenter::Manufacturer.first.to_param, :manufacturer => {:name => "3243", :asn => "string"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Manufacturer.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => ForemanDatacenter::Manufacturer.first.to_param, :manufacturer => {:name => ForemanDatacenter::Site.first.name} }, session: set_session_user
        assert_redirected_to manufacturers_url
      end

      # def test_destroy
      #   manufacturer = ForemanDatacenter::Manufacturer.first
      #   # architecture.hosts.delete_all
      #   # architecture.hostgroups.delete_all
      #   delete :destroy, params: { :id => manufacturer }, session: set_session_user
      #   assert_redirected_to manufacturers_url
      #   assert !ForemanDatacenter::Manufacturer.exists?(manufacturer.id)
      # end

      test '403 response contains missing permissions' do
        setup_user
        get :edit, params: { :id => ForemanDatacenter::Manufacturer.first.id }, session: {:user => users(:one).id, :expires_at => 5.minutes.from_now}
        assert_response :forbidden
        assert_includes @response.body, 'edit_manufacturers'
      end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      def get_factory_name
        :manufacturer
      end
    end
  end
end
