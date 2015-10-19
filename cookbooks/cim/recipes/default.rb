#
# Cookbook Name:: cim
# Recipe:: default
# Author: Alex <aleksandr.zaichko@gmail.com>
# 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


include_recipe 'atg10.0.3'
include_recipe 'user'
include_recipe 'jboss5.1'

path_to_cim = "#{node['atg']['atg_home']}/bin"
exec_cim = "#{path_to_cim}/cim.sh"

user = node['user']['user_name']
group = node['user']['group_name']

path_to_butch_files = "/home/#{user}"

node.default['cim']['path_to_jdbc_driver'] = "/home/#{user}/#{node['cim']['jdbc_driver']}"
path_to_jdbc_driver = node['cim']['path_to_jdbc_driver']

node.default['cim']['jboss_home'] = node['jboss']['jboss_home']
node.default['cim']['user'] = node['user']['user_name']




execute 'env_for_ora_persist' do
  command "echo 'export LANG=en_US.UTF-8' >> /etc/profile"
end

execute 'env_for_ora' do
  command "export LANG=en_US.UTF-8"
end


remote_file path_to_jdbc_driver do
  source "#{node['cim']['jdbc_driver_url']}"
  mode '0755'
  not_if { ::File.exists?("#{path_to_jdbc_driver}") }
end


template "/home/#{user}/batch.cim" do
    source "batch.cim.erb"
  end

node['cim']['tasks'].each do |task|
  template "/home/#{user}/#{task}_batch.cim" do
    source "#{task}_batch.cim.erb"
  end
end

cookbook_file "run_cim_in_recursive_mode.sh" do
  path "/home/developer/run_cim_in_recursive_mode.sh"
  mode '0777'
end

cookbook_file "run_cim_using_batch_files.sh" do
  path "/home/developer/run_cim_using_batch_files.sh"
  mode '0777'
end

cookbook_file "flags.sh" do
  path "/etc/init.d/flags.sh"
  mode '0777'
  not_if { ::File.exists?("/etc/init.d/flags.sh") }
end

if node['cim']['use_dump_files']
then
  execute "exclude_run_level" do
    command 'echo "CIM_CREATE_PUB_SCHEMA_FLAG=0
CIM_IMPORT_PUB_DATA_FLAG=0
CIM_CREATE_A_SCHEMA_FLAG=0
CIM_IMPORT_A_DATA_FLAG=0	
CIM_CREATE_B_SCHEMA_FLAG=0
CIM_IMPORT_B_DATA_FLAG=0	
CIM_CREATE_CORE_SCHEMA_FLAG=0
CIM_IMPORT_CORE_DATA_FLAG=0	
" >> /etc/init.d/flags.sh'
  end
end

execute 'chown' do
  command "chown -R #{user}:#{group} /home/#{user} "
end

if node['cim']['run_cim']
  execute "run_cim" do
    command "su - #{user} -c \"/home/#{user}/run_cim_using_batch_files.sh > /home/#{user}/run_cim.log\""
  end
end

platform_version = node['platform_version']
version = platform_version[0].chr.to_i
if (version >= 7)
  template "/home/developer/run_pub_prod.sh" do
    source "run_pub_prod7.sh.erb"
    mode 0755 
  end  
else
  template "/home/developer/run_pub_prod.sh" do
    source "run_pub_prod.sh.erb"
    mode 0755 
  end
end



   