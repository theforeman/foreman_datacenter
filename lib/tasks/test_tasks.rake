# Tasks
namespace :foreman_datacenter do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      Comment.create({content: "TEST ++++++++++++++++++++"})
      ForemanDatacenter::Comment.create({content: "TEST ______________________"})
      Comment.create(content: "TEST ################")
      ForemanDatacenter::Comment.create(content: "TEST @@@@@@@@@@@@@@@@@@@@")
    end
  end
end

