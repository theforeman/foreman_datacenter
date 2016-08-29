class AddHostRefToDevices < ActiveRecord::Migration
  def change
    add_reference :devices, :host, index: true
  end
end
