class AddHostRefToDevices < ActiveRecord::Migration[4.2]
  def change
    add_reference :devices, :host, index: true
  end
end
