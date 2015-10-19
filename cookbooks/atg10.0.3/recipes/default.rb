#
# Cookbook Name:: atg10.0.3
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

include_recipe "user"
user = node['user']['user_name']
group = node['user']['group_name']


atg_dir = node['atg']['atg_soft_dir']
atg_name = node['atg']['name']
cache = Chef::Config[:file_cache_path]
file_cache_path = "#{cache}/#{atg_name}.bin"
atg_installer = file_cache_path

remote_file file_cache_path do
  source "#{node['atg']['url']}"
  owner "#{user}"
  group "#{group}"
  mode '0755'
  action :create
  not_if { ::File.exists?(file_cache_path) }
end

template "/etc/profile.d/atg.sh" do
  owner "root"
  group "root"
  mode "0755"
  source "atg.sh.erb"
end

directory atg_dir do
  owner "#{user}"
  group "#{group}"
  mode "0755"
  recursive true
end

template "/tmp/atg_installer.properties" do
  owner "#{user}"
  group "#{group}"
  source 'atg_installer.properties.erb'
  mode 00644
end

execute "install_atg_core" do	
  user 'root'
  command "su - #{user} -c \"#{atg_installer} -i silent -f /tmp/atg_installer.properties\" "
  not_if { ::File.exists?("#{node['atg']['install_dir']}") }
end


if node['atg']['need_store_install']
   include_recipe "atg10.0.3::atg_store" 
end



