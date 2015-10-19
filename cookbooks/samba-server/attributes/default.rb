# Cookbook Name:: samba-server
# Author: Alex <aleksandr.zaichko@gmail.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



default['samba']['service'] = ''



case node['platform_family'] 
  when 'debian'
    default['samba']['service'] = 'smbd'
  when 'rhel'
    default['samba']['service'] = 'smb'
end	


default['samba']['workgroupe'] = 'WORKGROUP'

default['samba']['atg_directory'] = '/opt/ATG'
default['samba']['jboss_directory'] = '/usr/share/jboss-5.1.0.GA'
default['samba']['public_directory'] = [node['samba']['atg_directory'], node['samba']['jboss_directory']]

default['samba']['path_for_config'] = '/etc/samba/smb.conf'
default['samba']['allowed_hosts_and_nets'] = '192.168.1. 127.0.0.1'
default['samba']['log_directory'] = 'var/log/samba'
default['samba']['name_of_interface'] = 'eth0'
default['samba']['net'] = '192.168.1.0'


default['samba']['if_new_user'] = false 
default['samba']['if_existed_user'] = true 


default['samba']['samba_group'] = 'samba_users' 
default['samba']['samba_user'] = 'nil' 

default['samba']['samba_user_password'] = 'developer' 







