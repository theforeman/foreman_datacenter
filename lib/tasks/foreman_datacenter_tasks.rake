# Tests
namespace :test do
  desc 'Test ForemanDatacenter'
  Rake::TestTask.new(:foreman_datacenter) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_datacenter do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_datacenter) do |task|
        task.patterns = ["#{ForemanDatacenter::Engine.root}/app/**/*.rb",
                         "#{ForemanDatacenter::Engine.root}/lib/**/*.rb",
                         "#{ForemanDatacenter::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_datacenter'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_datacenter']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_datacenter', 'foreman_datacenter:rubocop']
end
