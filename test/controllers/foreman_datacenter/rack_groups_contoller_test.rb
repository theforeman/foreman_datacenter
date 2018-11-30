require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class RackGroupsControllerTest < ActionController::TestCase
    describe ForemanDatacenter::RackGroupsController do
      setup do
        @model = ForemanDatacenter::RackGroup.first
        # @factory_options = :with_site
      end

      basic_index_test 'rack_groups'
      basic_new_test
      basic_edit_test 'rack_group'
      basic_pagination_per_page_test
      basic_pagination_rendered_test

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_rack_groups']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_rack_groups']"
      end

      def test_show_edit_button_id
        get :show, params: { :id => ForemanDatacenter::RackGroup.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_rack_groups_#{ForemanDatacenter::RackGroup.first.id}_edit']"
      end

      def test_show_delete_button_id
        get :show, params: { :id => ForemanDatacenter::RackGroup.first.to_param }, session: set_session_user
        assert_select "[data-id='aid_datacenter_rack_groups_#{ForemanDatacenter::RackGroup.first.id}']"
      end

      def test_create_invalid
        ForemanDatacenter::RackGroup.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :rack_group => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::RackGroup.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :rack_group => {:name => 'test rg'} }, session: set_session_user
        assert_redirected_to rack_groups_url
      end

      def test_edit_submit_button_id
        get :edit, params: { :id => ForemanDatacenter::RackGroup.first }, session: set_session_user
        assert_select "[data-id='aid_update_foreman_datacenter_rack_group']"
      end

      def test_update_invalid
        ForemanDatacenter::RackGroup.any_instance.stubs(:valid?).returns(false)
        put :update, params: { :id => ForemanDatacenter::RackGroup.first.to_param, :rack_group => {:name => "3243"} }, session: set_session_user
        assert_template 'edit'
      end

      def test_update_valid
        ForemanDatacenter::RackGroup.any_instance.stubs(:valid?).returns(true)
        put :update, params: { :id => ForemanDatacenter::RackGroup.first.to_param, :rack_group => {:name => ForemanDatacenter::RackGroup.first.name} }, session: set_session_user
        assert_redirected_to rack_groups_url
      end

      # def test_destroy
      #   rack_group = ForemanDatacenter::RackGroup.first
      #   # architecture.hosts.delete_all
      #   # architecture.hostgroups.delete_all
      #   delete :destroy, params: { :id => rack_group }, session: set_session_user
      #   assert_redirected_to rack_groups_url
      #   assert !ForemanDatacenter::RackGroup.exists?(rack_group.id)
      # end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      def get_factory_name
        :rack_group
      end
    end
  end
end
