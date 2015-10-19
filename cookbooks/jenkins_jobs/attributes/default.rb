# Cookbook name: jenkins_jobs
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



#Global settings--------------------------------------------------------------------------------------

default['jenkins']['jenkins_port'] = '10000'
default['jenkins']['jvm_options'] = ''
default['jenkins']['maven_global_options'] = ''

default['jenkins']['listen_address'] = '0.0.0.0'
default['jenkins']['url'] = "http:"+"//localhost:#{node['jenkins']['jenkins_port']}"
default['jenkins']['dir_for_atr'] = '/tmp/jenkins_atr'
default['jenkins']['hulf_stuff_atr'] = "#{node['jenkins']['dir_for_atr']}/jenkins_half_staff"
default['jenkins']['encode_atr'] = "#{node['jenkins']['dir_for_atr']}/jenkins_atr_in_encode"


#=================================================================================

# Settings for creature job--------------------------------------------------------
default['jenkins']['module_set'] = ''

default['jenkins']['need_new_job'] = true
default['jenkins']['need_conf_job'] = true
default['jenkins']['run_job_now'] == false
default['jenkins']['name_of_new_job'] = 'Assembling'
default['jenkins']['deskription_of_new_job'] = 'Assemble ear files'

#This can be overridden as: 'maven_project', 'external_job', 'multi-configuration project'.
default['jenkins']['kind_of_job'] = 'free_style'

case node['jenkins']['kind_of_job']
  when 'free_style'
    default['jenkins']['module_set'] = 'hudson.model.FreeStyleProject'
end 

default['jenkins']['path_to_script_in_system'] = '/tmp/script_job.sh'

default['jenkins']['jenkins_shel_job'] = node['jenkins']['path_to_script_in_system']
#default['jenkins']['jenkins_shel_job'] = \
#"/opt/ATG/ATG/10.0.3/home/bin/runAssembler ATGproduction.ear -m DafEar.Admin DPS DSS \
#B2CCommerce DCS.PublishingAgent DCS.AbandonedOrderServices Store.Storefront Store.Fulfillment"

default['jenkins']['jenkins_job_workspace'] = "/var/lib/jenkins/jobs/#{node['jenkins']['name_of_new_job']}/workspace"
default['jenkins']['jenkins_dir_for_artifakts'] = '/usr/share/jboss-5.1.0.GA/jenkins_stuff'

if node['platform_version'].to_i >=7
  node['jenkins']['jenkins_job_workspace'] = "/var/lib/jenkins/jobs/#{node['jenkins']['name_of_new_job']}/workspace"
end


default['jenkins']['comands_for_shell_job'] = \
"/opt/ATG/ATG/10.0.3/home/bin/runAssembler ATGpublishing.ear -m DCS-UI.Versioned BIZUI \
PubPortlet DafEar.Admin SiteAdmin.Versioned B2CCommerce.Versioned DCS.Versioned DCS-UI \
Store.EStore.Versioned Store.Storefront
/opt/ATG/ATG/10.0.3/home/bin/runAssembler ATGproduction.ear -m DafEar.Admin DPS DSS \
B2CCommerce DCS.PublishingAgent DCS.AbandonedOrderServices Store.Storefront Store.Fulfillment"

#If job is maven_project kind, this attributes must be defind.
if node['jenkins']['kind_of_job'] == 'free style'
  default['jenkins']['name_of_maven'] = 'maven'
  default['jenkins']['maven_home'] = ''
  case node['platform_family']
	when 'debian'
  default['jenkins']['maven_home'] = ''
	when 'rhel'
  default['jenkins']['maven_home'] = ''
  end  
  default['jenkins']['maven_opts'] = ''
  default['jenkins']['module_set'] = 'hudson.maven.MavenModuleSet'
  default['jenkins']['pom_root'] = 'pom.xml'
end

#If jenkins uses Git repo for example
default['jenkins']['repo_user_login'] = ''
default['jenkins']['repo_user_password'] = ''
default['jenkins']['deskription_repo_cred'] = 'cred_for_remote_repo'
default['jenkins']['credentials_id'] = '7a57f152-3f3d-495a-91a0-50a5081e1975'
default['jenkins']['url_of_remote_project'] = 'https://aleksZ1975@bitbucket.org/vitaliyZ/realestate.git'

default['jenkins']['copy_item_from'] = ''

case node['jenkins']['module_set'] 
  when 'Copy existing Item'
    default['jenkins']['copy_item_from'] = ''
end  

default['jenkins']['email_recipients'] = 'aleksandr.zaichko@gmail.com'

#If job must be under scheduleing
default['jenkins']['schedule'] = false
if node['jenkins']['schedule']
  default['jenkins']['schedule_checks_commits'] = ''
end

#----------------------------------------------------------------------------------
  
