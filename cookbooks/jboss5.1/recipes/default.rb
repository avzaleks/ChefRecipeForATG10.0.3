#
# Cookbook Name:: jboss5.1
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

include_recipe "java6"
node.default['jboss']['java_home'] = node['java']['java_home']


node.default['jboss']['jboss_user'] = node['user']['user_name']

jboss_dir = node['jboss']['dir_for_jboss']
jboss_home = node['jboss']['jboss_home']

      
package 'unzip' do
  action :install
end	
    
cache = Chef::Config[:file_cache_path]
file_cache_path = "#{cache}/jboss-5.1.0.GA.zip"

remote_file file_cache_path do
  source "#{node['jboss']['url']}"
  mode '0644'
  not_if { ::File.exists?(file_cache_path) }
end

directory node['jboss']['jboss_home'] do
  owner "#{user}"
  group "#{group}"
  action :create
end
   
execute 'unzip' do
  command "su - #{user} -c \"unzip #{file_cache_path} -d #{jboss_dir}\""
  not_if { ::File.exists?("#{jboss_home}/bin/run.sh") }
end
 
file '/etc/profile.d/jbs.sh' do
  owner 'root'
  group 'root'
  mode '0700'
  content "export JBOSS_HOME=#{jboss_home} "
end
 
template '/etc/init.d/jboss' do
  mode 0755
  source 'start_script.erb'
end   
  
service 'jboss' do
#  supports :restart => true, :stop => true
  action :start 
end
#check_comand = "ps -ef | grep -v 'auto' | grep '/usr/share/jboss-5.1.0.GA/bin/run.sh -c default -b 0.0.0.0'"

#if node['jboss']['start_now']
#  execute 'run_jboss' do
#    command '/etc/init.d/jboss start'
#    not_if { ::File.exists?("#{jboss_home}/jbdef.log") }
#  end
#end	
