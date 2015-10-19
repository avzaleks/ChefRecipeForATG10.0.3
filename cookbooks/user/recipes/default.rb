#
# Cookbook Name:: user
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


user = node['user']['user_name']
group = node['user']['group_name']
pswd = node['user']['user_password']


group group do
  action :create
end

user user do
  comment 'User for jboss and ATG'
  gid "#{group}"
  shell '/bin/bash'
end

pass = '/tmp/pass1'
str = "#{pswd}\n#{pswd}"

bash 'passwd' do
  user 'root'
  code <<-EOF
		echo -e "#{str}" >/tmp/pass
	    cat /tmp/pass | passwd "#{user}"
	EOF
end		
		




