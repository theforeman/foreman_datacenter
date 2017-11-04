# Tasks
namespace :foreman_datacenter do
  desc 'Devices tasks'
  task side: :environment do
    # updating :side attribute for devices without :side
    Device.all.each do |device|
      if device.side.nil?
        device.update_attribute(side: 2)
      end
    end
  end

  task size: :environment do
    # updating :size attribute according to device_type.u_height
    Device.all.each do |device|
      if device.device_type
        device.update_attribute(size: device.device_type.u_height)
      end
    end
  end
end

# TODO
# comments
