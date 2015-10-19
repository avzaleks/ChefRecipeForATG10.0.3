#
# Cookbook Name:: java6
# Recipe:: default
#
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

include_recipe "user"
user = node['user']['user_name'] 
group = node['user']['group_name']


version = node['java']['version']
cache = Chef::Config[:file_cache_path]
file_cache_path = "#{cache}/#{node['java']['bin_arch']}"

remote_file file_cache_path do
  source "#{node['java']['url']}"
  mode '0644'
  not_if { ::File.exists?(file_cache_path) }
end

java_dir = node['java']['dir']
java_name = node['java']['name']

directory "#{java_dir}" do
  owner "#{user}"
  group "#{group}"
  mode '0755'
  recursive true
  action :create
end

execute "copy" do
  command "su - #{user} -c \"cp #{file_cache_path} #{java_dir} \""
  not_if { ::File.exists?("#{java_dir}/#{node['java']['bin_arch']}") }
end

execute "copy" do
  command "chmod 755 #{java_dir}/#{node['java']['bin_arch']}"
end

#execute "inflating" do
#  command "sh /usr/lib/jvm/jdk-6u45-linux-x64.bin"
#  not_if { ::File.exists?("#{java_dir}/#{java_name}") }
#end

bash 'extract_module' do
  cwd "#{java_dir}"
  code <<-EOH
    ./#{node['java']['bin_arch']}
	chown -R #{user}:#{group} #{java_dir} 
	EOH
#  not_if { ::File.exists?(extract_path) }
end

#package 'glibc.i686' do
#  action :install
#end	

file '/etc/profile.d/jdk.sh' do
  owner 'root'
  group 'root'
  mode '0755'
  content "export JAVA_HOME=#{node['java']['java_home']}
export JAVA_JRE=#{node['java']['java_home']}/jre
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_JRE"
  action :create
end

if node['platform_family']=="rhel" 

  execute 'yum groupinstall' do
    user 'root'
	command 'yum -y groupinstall "Compatibility libraries"'
  end

end
	  
	  
if node['platform_family']=="debian" 

end

  