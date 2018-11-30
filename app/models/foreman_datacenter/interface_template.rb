module ForemanDatacenter
  class InterfaceTemplate < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    FORM_FACTORS = ['Virtual', '10/100M (100BASE-TX)',
                    '1GE (1000BASE-T)', '1GE (SFP)', '10GE (10GBASE-T)',
                    '10GE (SFP+)', '10GE (XFP)', '40GE (QSFP+)']

    belongs_to :device_type, :class_name => 'ForemanDatacenter::DeviceType'

    validates :device_type_id, presence: true
    validates :name, presence: true, length: { maximum: 30 }
    validates :form_factor, inclusion: { in: FORM_FACTORS }

    scoped_search on: :name, complete_value: true, default_order: true

    def attrs_to_copy
      attributes.slice('name', 'form_factor', 'mgmt_only')
    end
  end
end
