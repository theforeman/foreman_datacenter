module ForemanDatacenter
  module ApplicationHelper

    def help_button
      if request.env['PATH_INFO'].include?("datacenter")
	link_to(_("Help"), { :action => "welcome" }, { :class => 'btn btn-default' }) if File.exist?("#{ForemanDatacenter::Engine.root}/app/views/foreman_datacenter/#{controller_name}/welcome.html.erb")
      else
	super
      end
    end

    def documentation_url(section = "", options = {})
      if request.env['PATH_INFO'].include?("datacenter")
	root_url = options[:root_url] || "https://github.com/theforeman/foreman_datacenter/wiki"
	if section.empty?
	  "https://github.com/theforeman/foreman_datacenter/wiki"
	else
	  root_url + section
	end
      else
	super
      end
    end

    def display_fake_delete_if_authorized(options = {}, html_options = {}, as = 'button')
      text = options.delete(:text) || _("Delete")
      method = options.delete(:method) || :delete
      options = {:auth_action => :destroy}.merge(options)
      html_options = {}.merge(html_options)
      if authorized_for(options)
        link_to(text, options, html_options)
      else
        ""
      end
    end

    def recursive_tags(text, tags)
      return _("#{text}") if tags.empty?
      ct = tags[0].parameterize.underscore.to_sym
      if tags.length == 1
        content_tag(ct, _("#{text}"), class: 'text-muted')
      else
        content_tag(ct, recursive_tags(text, tags.drop(1)))
      end
    end

    def muted_text(text, *ct)
      recursive_tags(text, ct)
    end

    def associated_objects(object)
      case object
      when 'site'
        '(Racks, RackGroups, Devices, Interfaces, Ports, etc)'
      when 'rack_group'
        '(Racks, Devices, Interfaces, Ports, etc)'
      when 'rack'
        '(Devices, Interfaces, Ports, etc)'
      when 'platform'
        '(Devices, Interfaces, Ports, etc)'
      when 'device'
        '(Interfaces, Ports, etc)'
      when 'device_role'
        '(Devices)'
      when 'device_type'
        '(Devices)'
      when 'manufacturer'
        '(DeviceTypes, Templates, Devices, Interfaces, Port)'
      else
        '(...)'
      end
    end

    def object_path(object)
      object_name = object.model_name.plural.gsub("foreman_datacenter_","")
      "/datacenter/#{object_name}/#{object.id}"
    end

    def object_name(object)
      object.model_name.element
    end

    def search_params(objects, parameter, sp)
      str = ""
      objects.each_with_index do |o, i|
        str += ' or ' if i > 0
        str += "#{sp}=#{o.send(parameter)}"
      end
      return str
    end
  end
end
