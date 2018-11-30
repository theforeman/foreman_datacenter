require_relative '../../test_plugin_helper'

module ForemanDatacenter
  class PowerPortTemplatesControllerTest < ActionController::TestCase
    describe ForemanDatacenter::PowerPortTemplatesController do
      setup do
        @model = ForemanDatacenter::PowerPortTemplate.first
      end

      basic_new_test

      def test_new_submit_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_power_port_templates']"
      end

      def test_new_cancel_button_id
        get :new, session: set_session_user
        assert_select "[data-id='aid_datacenter_power_port_templates']"
      end
      
      def test_create_invalid
        ForemanDatacenter::PowerPortTemplate.any_instance.stubs(:valid?).returns(false)
        post :create, params: { :power_port_template => {:name => nil} }, session: set_session_user
        assert_template 'new'
      end

      def test_create_valid
        ForemanDatacenter::PowerPortTemplate.any_instance.stubs(:valid?).returns(true)
        post :create, params: { :power_port_template => {:name => 'test site'} }, session: set_session_user
        assert_redirected_to power_port_templates_url
      end

      # def test_destroy
      #   power_port_template = ForemanDatacenter::PowerPortTemplate.first
      #   # architecture.hosts.delete_all
      #   # architecture.hostgroups.delete_all
      #   delete :destroy, params: { :id => power_port_template }, session: set_session_user
      #   assert_redirected_to power_port_templates_url
      #   assert !ForemanDatacenter::PowerPortTemplate.exists?(power_port_template.id)
      # end

      def setup_user
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by_name('Viewer')]
      end

      def get_factory_name
        :power_port_template
      end
    end
  end
end
