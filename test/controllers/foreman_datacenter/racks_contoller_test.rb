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

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_racks']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_racks']"
      end

      def test_show_edit_button_id
        get :show, params: { :id => ForemanDatacenter::Rack.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_racks_#{ForemanDatacenter::Rack.first.id}_edit']"
      end

      def test_show_delete_button_id
        get :show, params: { :id => ForemanDatacenter::Rack.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_datacenter_racks_#{ForemanDatacenter::Rack.first.id}']"
      end

      def test_create_invalid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :rack => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :rack => {:name => 'test rg'} }, session: set_session_user
        assert_redirected_to racks_url
      end

      def test_edit_submit_button_id
        get :edit, params: { :id => ForemanDatacenter::Rack.first }, session: set_session_user
        assert_select "[data-id='aid_update_foreman_datacenter_rack']"
      end

      def test_update_invalid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => ForemanDatacenter::Rack.first.to_param, :rack => {:name => "3243"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::Rack.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => ForemanDatacenter::Rack.first.to_param, :rack => {:name => ForemanDatacenter::Rack.first.name} }, session: set_session_user
        assert_redirected_to racks_url
      end

      # def test_destroy
      #   rack = ForemanDatacenter::Rack.first
      #   # architecture.hosts.delete_all
      #   # architecture.hostgroups.delete_all
      #   delete :destroy, params: { :id => rack }, session: set_session_user
      #   assert_redirected_to racks_url
      #   assert !ForemanDatacenter::Rack.exists?(rack.id)
      # end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      def get_factory_name
        :rack
      end
    end
  end
end
