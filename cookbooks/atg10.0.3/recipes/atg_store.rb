#
# Cookbook Name:: atg10.0.3
# Recipe:: atg_store
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

store_name=node['atg']['store_name']

cache = Chef::Config[:file_cache_path]
file_cache_path = "#{cache}/#{store_name}.bin"
store_installer = file_cache_path

remote_file file_cache_path do
  source "#{node['atg']['store_url']}"
  mode '0755'
  not_if { ::File.exists?(file_cache_path) }
end

template "/tmp/store_installer.properties" do
  source 'store_installer.properties.erb'
  mode 00644
end

execute "install_atg_store" do	
  user 'root'
  command "su - #{user} -c \"#{store_installer} -i silent -f /tmp/store_installer.properties\" "
  not_if { ::File.exists?("#{node['atg']['install_dir']}/#{node['atg']['store']}") }
end



