require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

targets = YAML.load_file('properties/targets.yml')

task spec:    'spec:all'
task default: :spec

namespace :spec do
  task all: targets.keys

  targets.each do |environment, hosts|
    desc "Run serverspec tests to all hosts in #{environment}"
    task environment => "#{environment}:all"

    namespace environment do
      task all: hosts.map { |h| h[:name].to_sym }

      hosts.each do |host|
        desc "Run serverspec tests to #{host[:name]}"
        RSpec::Core::RakeTask.new(host[:name]) do |t|

          ENV['TARGET_HOST'] = host[:name]
          ENV['ENV']         = environment

          t.pattern = "spec/{#{ host[:roles].join(',') }}/*_spec.rb"
        end
      end
    end
  end
end
