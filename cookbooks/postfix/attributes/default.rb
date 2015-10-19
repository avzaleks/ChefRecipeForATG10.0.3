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

default['postfix']['mail_server_domain'] = 'gmail.com'
default['postfix']['server_port'] = '587'
default['postfix']['user_account_name'] = 'aleksandr.zaichko'
default['postfix']['identity_file_name'] = 'sasl_passwd'
default['postfix']['host_name'] = node['hostname']
default['postfix']['user_account_passwd'] = ''
default['postfix']['host_domain'] = 'example.com'
default['postfix']['test_mail_address'] = 'aleksforjob@gmail.com'

