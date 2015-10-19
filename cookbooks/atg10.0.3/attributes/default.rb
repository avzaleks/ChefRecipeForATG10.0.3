# Cookbook Name:: ATG10.0.3
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

default['atg']['atg_soft_dir'] = "/opt/ATG"

default['atg']['name'] = "ATG10.0.3"
default['atg']['url'] = "file:///tmp/Atg/#{node['atg']['name']}.bin"
default['atg']['version'] = "10.0.3"
default['atg']['app_server'] = "jboss-5.1.0.GA"
default['atg']['app_server_name'] = "JBoss"
default['atg']['jboss_home'] = "/usr/share/#{node['atg']['app_server']}"
default['atg']['java_home'] = "/usr/lib/jvm/jdk1.6.0_45"
default['atg']['listen_port'] = "8080"
default['atg']['rmi_port'] = "8860"
default['atg']['installer_name'] = "ATG10.0.3.bin"
default['atg']['install_dir'] = "#{node['atg']['atg_soft_dir']}/ATG/#{node['atg']['version']}"
default['atg']['atg_home'] = "#{node['atg']['install_dir']}/home"

default['atg']['need_store_install'] = true
default['atg']['store'] = "CommerceReferenceStore"
default['atg']['store_version'] = "10.0.3.2"
default['atg']['store_name'] =  "#{node['atg']['store']}#{node['atg']['store_version']}"
default['atg']['store_url'] = "file:///tmp/Atg/#{node['atg']['store_name']}.bin"
default['atg']['store_install_dir'] = "#{node['atg']['install_dir']}"
default['atg']['store_installer_name'] = "#{node['atg']['store_name']}.bin"
default['atg']['feature_list'] = "RM,Commerce,Portal,CA"

