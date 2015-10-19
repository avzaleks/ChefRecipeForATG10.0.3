#
# Cookbook Name:: oracle11
# Recipe:: set_user
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
user_uid = node['ora']['user_uid'] 
group = node['ora']['group']
group_gid = node['ora']['group_gid'].to_i

pswd = node['ora']['user_password']

if "cat /etc/group | grep #{group_gid}" 
   group_gid = group_gid + 1
end

group group do 
  gid "#{group_gid}"  
end

directory "#{node['ora']['ora_user_home']}" do
  recursive true
end


user user do
  uid "#{user_uid}"
  gid "#{group}"
  supports :manage_home => true
  comment 'Oracle Administrator'
  home '/u01/app/oracle/'
end

execute 'chown_ora_home' do
  command "chown -Rf #{user}:#{group} #{node['ora']['ora_user_home']}"
end



str = "#{pswd}\n#{pswd}"

bash 'passwd' do
  user 'root'
  code <<-EOF
		echo -e "#{str}" >/tmp/pass
	    cat /tmp/pass | passwd "#{user}"
	    EOF
end		
		



