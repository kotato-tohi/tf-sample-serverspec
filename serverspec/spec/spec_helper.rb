require 'serverspec'
require 'net/ssh'
require 'specinfra'
 
# include SpecInfra::Helper::Ssh
# include SpecInfra::Helper::DetectOS

# include Serverspec::Helper::Ssh
# include Serverspec::Helper::DetectOS

set :backend, :ssh


RSpec.configure do |c|
  c.host  = ENV['TARGET_HOST']
  options = Net::SSH::Config.for(c.host)
  user    = 'ec2-user'
  c.ssh   = Net::SSH.start(c.host, user, :keys => ['~/pem/common_key.pem'])
  c.os    = backend(Serverspec::Commands::Base).check_os
  # c.os    = :backend
end
# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
