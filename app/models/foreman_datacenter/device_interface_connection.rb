module ForemanDatacenter
  class DeviceInterfaceConnection < ActiveRecord::Base
    include ScopedSearchExtensions
    include Authorizable

    belongs_to :first_interface, class_name: 'ForemanDatacenter::DeviceInterface',
               foreign_key: 'interface_a'
    belongs_to :second_interface, class_name: 'ForemanDatacenter::DeviceInterface',
               foreign_key: 'interface_b'

    enum connection_status: [:connected, :planned]

    validates :interface_a, presence: true
    validates :interface_b, presence: true

    validate do
      if interface_a == interface_b
        errors.add(:interface_b, 'Cannot connect an interface to itself')
      end
    end

    # scoped_search relation: :device, on: :name, ext_method: :a
    scoped_search on: :interface_a, complete_value: true, default_order: true
    # scoped_search :relation => :device, :on => :name#, :rename => :role_id, :complete_enabled => false, :only_explicit => true, :validator => ScopedSearch::Validators::INTEGER
    # scoped_search :relation => :interface, :on => :name, :rename => :interface_id#, :complete_enabled => false, :only_explicit => true, :validator => ScopedSearch::Validators::INTEGER
    # scoped_search on: :device_a, complete_value: true, default_order: true
    # scoped_search on: :device_b, complete_value: true, default_order: true
    # scoped_search :relation => :role, :on => :id, :rename => :role_id, :complete_enabled => false, :only_explicit => true, :validator => ScopedSearch::Validators::INTEGER


    # def self.a
    # select device_interfaces.Device_id from device_interfaces;
    #   # def self.a(key, operator, value)
    #   interface_ids = DeviceInterfaceConnection.all.map{|d| [d.interface_a, d.interface_b]}.flatten.uniq
    #   device_ids = DeviceInterface.where(id: interface_ids).map(&:device_id).uniq
    #   
    #   # conditions = sanitize_sql_for_conditions(["houses.name #{operator} ?", value_to_sql(operator, value)])
    #   # owners = Person.joins(:houses).where(conditions).select('person.name').map(&:id)
    #   #owners = Device.joins(:houses).where(conditions).select('person.name').map(&:id)
    #   # owners = Device.all
    #   # o = DeviceINterface.all
    #   # abort owners.inspect

    #   # # { :conditions => "person.name IN(#{owners.join(',')})" }
    #   { :conditions => "device.name IN(#{device_ids.join(',')})" }
    # end

    def first_device
      first_interface.device
    end

    def first_rack
      first_device.rack
    end

    def first_site
      first_rack.site
    end

    def second_device
      first_interface.device
    end

    def second_rack
      second_device.rack
    end

    def second_site
      second_rack.site
    end
  end
end
