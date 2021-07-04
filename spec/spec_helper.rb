require 'serverspec'
require 'net/ssh'
require 'yaml'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host        = ENV['TARGET_HOST']
environment = ENV['ENV']

properties_environment = YAML.load_file('properties/environments.yml')[environment]
properties_targets     = YAML.load_file('properties/targets.yml')[environment]
properties_target      = properties_targets.filter { |t| t[:name] == host }.first
properties             = properties_environment.merge(properties_target)

set_property properties

puts "# Host: #{host}"

options = Net::SSH::Config.for(host)

if ENV['ASK_LOGIN_PASSWORD']
  options[:password] = ask("Enter login password: ") { |q| q.echo = false }
else
  options[:password] = ENV['LOGIN_PASSWORD']
end

options[:user] = properties[:ssh_user] || options[:user] || Etc.getlogin
options[:port] = properties[:ssh_port] || options[:port] || 22
options[:keys] = properties[:ssh_keys] || options[:keys]

set :host,        properties[:ssh_host]  || options[:host_name] || host
set :ssh_options, options
