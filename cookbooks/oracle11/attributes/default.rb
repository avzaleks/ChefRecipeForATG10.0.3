# Cookbook Name:: oracle11
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
default['ora']['rpm_name'] = "oracle-xe-11.2.0-1.0.x86_64.rpm"
default['ora']['zip_name'] = "#{node['ora']['rpm_name']}.zip"
default['ora']['cli_bas_rpm_name'] = "oracle-instantclient11.2-basic-11.2.0.3.0-1.x86_64.rpm"
default['ora']['cli_bas_zip_name'] = "#{node['ora']['cli_bas_rpm_name']}.zip"

default['ora']['run_per_se'] = false

default['ora']['cli_sql_rpm_name'] = "oracle-instantclient11.2-sqlplus-11.2.0.3.0-1.x86_64.rpm"
default['ora']['cli_sql_zip_name'] = "#{node['ora']['cli_sql_rpm_name']}.zip"

default['ora']['ora_user_home'] = "/u01/app/oracle"

default['ora']['soft_dir'] = "/opt/oracle"

default['ora']['ora_url'] = "file:///tmp/Atg/"
default['ora']['dep_packages'] = ['binutils', 'compat-libcap1', 'compat-libstdc++-33',
                                  'gcc', 'gcc-c++', 'glibc', 'glibc-devel', 'ksh', 'unzip',
								  'libgcc', 'libstdc++', 'libstdc++-devel', 'libaio',
                                  'libaio-devel', 'make', 'sysstat', 'net-tools','bc']

default['ora']['sel_pol'] = ['oracle-xe-selinux', 'oracle-instantclient-selinux',
                             'oracle-instantclient-sqlplus-selinux']								  
								  
default['ora']['user'] = 'oracle'								  
default['ora']['user_uid'] = '200'								  
default['ora']['user_shell'] = '/bin/ksh'
default['ora']['group'] = 'dba'
default['ora']['group_gid'] = '200'
default['ora']['user_password'] = 'qwertyqaz'								  


default['ora']['ora_home'] = "/u01/app/oracle/product/11.2.0/xe"
default['ora']['ora_sid'] = 'XE'
default['ora']['ora_admin_port'] = '7070'
default['ora']['ora_listen_port'] = '1521'
default['ora']['db_password'] = 'qazqaz'								  

default['ora']['use_dump_files'] = true								  
default['ora']['dump_files'] = ['PUB.DMP','CATA.DMP','CATB.DMP','CORE.DMP']								  
default['ora']['dump_dir'] = "#{node['ora']['ora_user_home']}/product/11.2.0/xe/rdbms/log"
default['ora']['second_dump_dir'] = "#{node['ora']['ora_user_home']}/admin/XE/dpdump"



default['ora']['iptables_need_source_net'] = false
default['ora']['iptables_source_net'] = ''

if node['ora']['iptables_need_source_net']
  default['ora']['iptables_source_net'] = "-s #{node['ora']['iptables_source_net']}"
end

default['ora']['pub_user'] = 'pub'
default['ora']['pub_user_pswd'] = 'pub'
default['ora']['a_user'] = 'cata'
default['ora']['a_user_pswd'] = 'cata'
default['ora']['b_user'] = 'catb'
default['ora']['b_user_pswd'] = 'catb'
default['ora']['core_user'] = 'core'
default['ora']['core_user_pswd'] = 'core'














