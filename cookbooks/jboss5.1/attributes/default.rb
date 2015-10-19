#
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
default['jboss']['version'] = 'jboss-5.1.0.GA'
default['jboss']['dir_for_jboss'] = '/usr/share'
default['jboss']['jboss_home'] = "/usr/share/#{node['jboss']['version']}"
default['jboss']['url'] = 'file:///tmp/Atg/jboss-5.1.0.GA.zip'
default['jboss']['admin_login'] = 'admin'

default['jboss']['admin_password'] = 'kukaracha'
default['jboss']['start_now'] = true

