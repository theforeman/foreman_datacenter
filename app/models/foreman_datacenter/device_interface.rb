module ForemanDatacenter
  class DeviceInterface < ActiveRecord::Base
    # include ScopedSearchExtensions
    # include Authorizable

    FORM_FACTORS = ['Virtual', '10/100M (100BASE-TX)',
                    '1GE (1000BASE-T)', '1GE (SFP)', '10GE (10GBASE-T)',
                    '10GE (SFP+)', '10GE (XFP)', '40GE (QSFP+)']
    DEFAULT_FORM_FACTOR = '1GE (1000BASE-T)'

    belongs_to :device, :class_name => 'ForemanDatacenter::Device'

    validates :device_id, presence: true
    validates :name, presence: true, length: {maximum: 30}
    validates :form_factor, inclusion: {in: FORM_FACTORS}
    validates :mac_address, length: {maximum: 128}
    validates :ip_address, length: {maximum: 128}
    validates :description, length: {maximum: 100}

    def connection
      @connection ||= DeviceInterfaceConnection.
        where(['interface_a = ? OR interface_b = ?', id, id]).
        first
    end

    def connected_interface
      @connected_interface ||= if connection
                                 if connection.interface_a == id
                                   connection.second_interface
                                 else
                                   connection.first_interface
                                 end
                               end
    end

    def connected?
      !connection.nil?
    end
  end
end
