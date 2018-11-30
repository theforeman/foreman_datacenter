FactoryBot.define do
  factory :rack_group, class: ForemanDatacenter::RackGroup do
    sequence(:name) { |n| "rg#{n}" }
    # sequence(:site_id) { |n| n }
    sequence(:site_id) { 1 }

    # trait :with_os_defaults do
    #   after(:create) do |os, evaluator|
    #     os.provisioning_templates.each do |tmpl|
    #       FactoryBot.create(:os_default_template,
    #                          :operatingsystem => os,
    #                          :provisioning_template => tmpl,
    #                          :template_kind => tmpl.template_kind)
    #     end
    #   end
    # end

    # trait :with_provision do
    #   provisioning_templates do
    #     [FactoryBot.create(:provisioning_template, :template_kind => TemplateKind.find_by_name('provision'))]
    #   end
    #   with_os_defaults
    # end

    # trait :with_pxelinux do
    #   provisioning_templates do
    #     [FactoryBot.create(:provisioning_template, :template_kind => TemplateKind.find_by_name('PXELinux'))]
    #   end
    #   with_os_defaults
    # end

    # trait :with_grub do
    #   provisioning_templates do
    #     [FactoryBot.create(:provisioning_template, :template_kind => TemplateKind.find_by_name('PXEGrub'))]
    #   end
    #   with_os_defaults
    # end

    trait :with_site do
      site { [FactoryBot.create(:site)] }
    end

    # trait :with_media do
    #   media { [FactoryBot.create(:medium)] }
    # end

    # trait :with_ptables do
    #   ptables { [FactoryBot.create(:ptable)] }
    # end

    trait :with_associations do
      with_site
    #   with_media
    #   with_ptables
    end

    # trait :with_parameter do
    #   after(:create) do |os, evaluator|
    #     FactoryBot.create(:os_parameter, :operatingsystem => os)
    #   end
    # end

    # factory :coreos, class: Coreos do
    #   sequence(:name) { 'CoreOS' }
    #   major '494'
    #   minor '5.0'
    #   type 'Coreos'
    #   release_name 'stable'
    #   title 'CoreOS 494.5.0'
    # end

    # factory :ubuntu14_10, class: Debian do
    #   sequence(:name) { 'Ubuntu' }
    #   major '14'
    #   minor '10'
    #   type 'Debian'
    #   release_name 'utopic'
    #   title 'Ubuntu Utopic'
    # end

    # factory :debian7_0, class: Debian do
    #   sequence(:name) { 'Debian' }
    #   major '7'
    #   minor '0'
    #   type 'Debian'
    #   release_name 'wheezy'
    #   title 'Debian Wheezy'
    # end

    # factory :suse, class: Suse do
    #   sequence(:name) { 'OpenSuse' }
    #   major '11'
    #   minor '4'
    #   type 'Suse'
    #   title 'OpenSuse 11.4'
    # end

    # factory :solaris, class: Solaris do
    #   sequence(:name) { 'Solaris' }
    #   major '10'
    #   minor '8'
    #   type 'Solaris'
    #   title 'Solaris 10.8'
    # end
  end
end

