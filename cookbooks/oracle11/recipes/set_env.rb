#
# Cookbook Name:: oracle11
# Recipe:: set_env
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

cookbook_file '/usr/make_swap.sh' do
  mode '0744'
end

execute 'make_swap' do
  command '/usr/make_swap.sh > /var/log/swap.log'
end

cookbook_file '/etc/ora_params' do
  mode '0744'
end

execute 'ora_params' do
  command 'sysctl -p /etc/ora_params'
end

template '/etc/security/limits.conf' do
  source 'ora_limit.erb'
end

template '/etc/pam.d/login' do
  source 'login.erb'
end

cookbook_file '/etc/profile.d/custom.sh' do
  mode '0744'
end

template '/etc/profile.d/ora.sh' do
  source 'ora.sh.erb'
  mode '0744'
end


