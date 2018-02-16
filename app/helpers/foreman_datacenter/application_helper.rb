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

  end
end
