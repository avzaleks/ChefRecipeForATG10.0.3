#
# Cookbook Name:: oracle11
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


include_recipe 'oracle11::set_user'
include_recipe 'oracle11::set_env'

if node['ora']['run_per_se']
  include_recipe 'oracle11::fwld'
end

user = node['ora']['user']
group = node['ora']['group']

ora_rpm_name = node['ora']['rpm_name']
ora_cli_base_rpm_name = node['ora']['cli_bas_rpm_name']
ora_cli_sql_rpm_name = node['ora']['cli_sql_rpm_name']

ora_archives = [ora_rpm_name, ora_cli_base_rpm_name, ora_cli_sql_rpm_name]

cache = Chef::Config[:file_cache_path]

pswd = node['ora']['db_password']

node['ora']['dep_packages'].each do |pack|
  package pack
end


ora_archives.each do |archive|
  file_cache_path = "#{cache}/#{archive}.zip"
  remote_file file_cache_path do
    source "#{node['ora']['ora_url']}/#{archive}.zip"
    mode '0666'
  not_if { ::File.exists?(file_cache_path) }
  end
end  

soft_dir = node['ora']['soft_dir'] 

directory soft_dir 

execute 'chown_soft_dir' do
  command "chown -Rf #{user}:#{group} #{soft_dir}"
end

file_ora_rpm = "#{soft_dir}/Disk1/#{ora_rpm_name}"
file_cache_path = "#{cache}/#{ora_rpm_name}.zip"

execute 'unzip_ora' do
  command "su - #{user} -c \" unzip #{file_cache_path} -d #{soft_dir}\""
  not_if { ::File.exists?(file_ora_rpm)} 
end

execute 'rpm_ora' do
  command "yum -y localinstall --nogpgcheck #{file_ora_rpm}"
  not_if { ::File.exists?('/etc/init.d/oracle-xe')}
end

ora_archives.shift



rsp_file ="#{soft_dir}/Disk1/response/xe.rsp"

template rsp_file do
  source 'xe.rsp.erb'
end

execute 'CONNECT_TIMEOUT_LISTENER' do
  user 'root'
  command "echo 'CONNECT_TIMEOUT_LISTENER=240' >>/u01/app/oracle/product/11.2.0/xe/network/admin/samples/listener.ora"
end

execute 'sqlnet.inbound_connect_timeout' do
  user 'root'
  command "echo 'sqlnet.inbound_connect_timeout = 240' >>/u01/app/oracle/product/11.2.0/xe/network/admin/samples/sqlnet.ora"
end



execute 'ora_config' do
  user 'root'
  command "/etc/init.d/oracle-xe configure responseFile=#{rsp_file} >> /tmp/XEsilentinstall.log"
  not_if { ::File.exists?('/u01/app/oracle/oradata/XE/users.dbf')}
end
ora_archives.each do |archive|
  file_cli_rpm = "#{soft_dir}/#{archive}"
  file_cache_path = "#{cache}/#{archive}.zip"
  execute 'unzip_clients' do
   command "su - #{user} -c \" unzip #{file_cache_path} -d #{soft_dir}\""
   not_if { ::File.exists?(file_cli_rpm)} 
  end
  execute 'rpm_cli_ora' do
    command "yum -y localinstall --nogpgcheck #{file_cli_rpm}"
  end
end

cookbook_file '/etc/yum.repos.d/spacewalk.repo' do
  mode '0644'
end
  
node['ora']['sel_pol'].each do |pack|
 package pack
end

if node['ora']['use_dump_files']
  then
    include_recipe 'oracle11::import'
  else
    include_recipe 'oracle11::create_users'
end 




