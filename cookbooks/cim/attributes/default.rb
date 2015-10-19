# Cookbook Name:: cim
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

default['cim']['jdbc_driver'] = 'ojdbc6.jar'
default['cim']['jdbc_driver_url'] = "file:///tmp/Atg/#{node['cim']['jdbc_driver']}"
default['cim']['path_to_jdbc_driver'] = ''

default['cim']['run_cim'] = true
default['cim']['use_dump_files'] = true
default['cim']['start_servers'] = false

default['cim']['ip_of_dbhost'] = '192.168.1.2'
default['cim']['port_of_dbhost'] = '1521'
default['cim']['db_sid'] = 'XE'
default['cim']['pub_user'] = 'pub'
default['cim']['pub_user_pswd'] = 'pub'
default['cim']['a_user'] = 'cata'
default['cim']['a_user_pswd'] = 'cata'
default['cim']['b_user'] = 'catb'
default['cim']['b_user_pswd'] = 'catb'
default['cim']['core_user'] = 'core'
default['cim']['core_user_pswd'] = 'core'
default['cim']['pub_serv_inst_name'] = 'ATGpublishing'
default['cim']['prod_serv_inst_name'] = 'ATGproduction'

default['cim']['tasks'] = ['prod_select', 'server_setup', 'create_pub_schema', 'create_a_schema',
							'create_b_schema', 'create_core_schema', 'import_pub_data',
							'import_a_data', 'import_b_data', 'import_core_data', 'other_tasks' ]

	


	






