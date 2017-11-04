# Tasks
namespace :foreman_datacenter do
  desc 'Devices tasks'
  task side: :environment do
    # updating :side attribute for devices without :side
    ForemanDatacenter::Device.all.each do |device|
      if device.side.nil?
        device.update_attribute(:side, 2)
      end
    end
  end

  task size: :environment do
    # updating :size attribute according to device_type.u_height
    ForemanDatacenter::Device.all.each do |device|
      if device.device_type
        device.update_attribute(:size, device.device_type.u_height)
      end
    end
  end

  task comments: :environment do
    # creating new comments from old_comments column and flushing it
    ForemanDatacenter::Device.all.each do |device|
      if device.old_comments != ""
        begin
          device.comments.create!(content: device.old_comments)
          device.update_attribute(:old_comments, "")
        rescue => e
          puts "#{e}"
        end
      end
    end
  end
end

