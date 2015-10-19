#
# Cookbook Name:: oracle11
# Recipe:: create_users
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

user = node['ora']['user']
group = node['ora']['group']
pswd = node['ora']['db_password']

sql_script = "#{node['ora']['ora_user_home']}/create_users.sql"
  
template sql_script do
  source 'create_users.sql.erb'
  owner "#{user}"
  group "#{group}"
  mode '0644'
  action :create
end	

ruby_block "timer" do
  block do
    sleep 10.0
  end
not_if { ::File.exists?("#{node['ora']['ora_user_home']}/user_already_created")}
end  
 
execute 'create_users' do
  command "sqlplus system/#{pswd}@#{node['ora']['ora_sid']} @#{sql_script} > cr_us.log"
end  
  
file "#{node['ora']['ora_user_home']}/user_already_created" do
  mode '0755'
  owner "#{user}"
  group "#{group}"
end  
  
  