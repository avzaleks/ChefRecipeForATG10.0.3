#/bin/bash

#sleep 5
#clear
ipOfTargetHost=''
use_dump_files=true
test_mail_address='aleksandr.zaichko@gmail.com'
ip_of_dbhost=''
start_servers=false
admin_addr_email='aleksandr.zaichko@gmail.com'
email_recipients='aleksandr.zaichko@gmail.com'

echo
echo
echo '         /  ###########   ############      ######      ###          ###  \'    
echo '        /   ###########   ############     ########     #####      #####   \'
echo '       /    ###           ###      ###    ###    ###    #######  #######    \'
echo '      /     ###           ###      ###   ###      ###   ################     \'
echo '     /      ########      ############   ############   ### ######## ###      \'
echo '     \      ########      ############   ############   ###   ####   ###      /'
echo '      \     ###           ###            ###      ###   ###          ###     /'
echo '       \    ###           ###            ###      ###   ###          ###    /'
echo '        \   ###########   ###            ###      ###   ###          ###   /'
echo '         \  ###########   ###            ###      ###   ###          ###  /'
echo
echo
echo "----- This resipe is for installing ATGcommers, Jenkins, Samba and Oracle 11 XE"
echo
echo



echo -n "----- Enter please ip of machine for ATG :"
read ipOfTargetHost
TMPF=adistro/"$ipOfTargetHost.tmp"
if [[ -e "$TMPF" ]]
then
    source "$TMPF"
else 
    touch $TMPF
    test_mail_address_tmp='aleksandr.zaichko@gmail.com'
    admin_addr_email_tmp='aleksandr.zaichko@gmail.com'	
    email_recipients_tmp='aleksandr.zaichko@gmail.com'	
fi
echo
echo "Thank you"
echo


echo -n "----- Enter please ip of machine for Oracle XE : [$ip_of_dbhost_tmp] "
read ip_of_dbhost
if [[ $ip_of_dbhost == '' ]]
then
    ip_of_dbhost=$ip_of_dbhost_tmp
fi
echo
echo "Thank you"
echo


echo -n "----- Enter please email for testing massage of postfix : [ $test_mail_address_tmp ] "
read test_mail_address
if [[ $test_mail_address == '' ]]
then
	if [[ $test_mail_address_tmp == '' ]]
	then
	test_mail_address='aleksandr.zaichko@gmail.com'
    else
	test_mail_address=$test_mail_address_tmp
    fi
fi
echo
echo "Thank you"
echo




echo -n "----- Enter please email of admin of Jenkins : [$admin_addr_email_tmp] "
read admin_addr_email
if [[ $admin_addr_email == '' ]]
then
	if [[ $admin_addr_email_tmp == '' ]]
	then
	admin_addr_email='aleksandr.zaichko@gmail.com'
    else
	admin_addr_email=$admin_addr_email_tmp
    fi
fi
echo
echo "Thank you"
echo




echo -n "----- Enter please email for Jenkins's job reports : [$email_recipients_tmp] "
read email_recipients
if [[ $email_recipients == '' ]]
then
	if [[ $email_recipients_tmp == '' ]]
	then
	email_recipients='aleksandr.zaichko@gmail.com'
    else
	email_recipients=$email_recipients_tmp
    fi
fi
echo
echo "Thank you"
echo




echo -n "----- How would you like to fill up database - with dump files or CIM (D/c) :"
read use_dump_files_str
if [[ $use_dump_files_str == 'c' ]]
	then
	use_dump_files=false
fi
echo
echo "Thank you"
echo 
echo 'Creating files for Chef run'
echo

echo "$ipOfTargetHost" > adistro/ipsmb.txt  
echo "ipOfTargetHost=$ipOfTargetHost" > $TMPF  
echo "ip_of_dbhost_tmp=$ip_of_dbhost" >> $TMPF  
echo "test_mail_address_tmp=$test_mail_address" >> $TMPF  
echo "admin_addr_email_tmp=$admin_addr_email" >> $TMPF  
echo "email_recipients_tmp=$email_recipients" >> $TMPF  

replasing(){
sed "/$2/d" "$1" | \
sed "s/ip_of_dbhost_template/$3/g" | \
sed "s/use_dump_files_template/$use_dump_files/g" | \
sed "s/test_mail_address_template/$test_mail_address/g" | \
sed "s/admin_addr_email_template/$admin_addr_email/g" | \
sed "s/email_recipients_template/$email_recipients/g" > "$4"
}



copy_files(){
echo "It is a fiction. It will be removed when using HTTP or NFS server (for example)!!!"
if [[ $1 == $2 ]]
	then
	if ssh root@$1 [[ -e /tmp/Atg ]]
		then
		echo "On the target machine already present required distributions. Continues ..."
		else
		echo "On the target machine lacks the necessary distributions. I will copy files ..."
		ssh root@$1 mkdir /tmp/Atg
		scp adistro/arch_for_atg10.0.3_java6_jBoss5.1/* root@$1:/tmp/Atg
		scp adistro/arch_for_oracle/* root@$1:/tmp/Atg
	fi
else
	if ssh root@$1 [[ -e /tmp/Atg ]]
		then
		echo "On the target machine already present required distributions. Continues ..."
		else
		echo "On the target machine lacks the necessary distributions. I will copy files ..."
		ssh root@$1 mkdir /tmp/Atg
		scp adistro/arch_for_atg10.0.3_java6_jBoss5.1/* root@$1:/tmp/Atg
	fi
	if ssh root@$2 [[ -e /tmp/Atg ]]
		then
		echo "On the target machine already present required distributions. Continues ..."
		else
		echo "On the target machine lacks the necessary distributions. I will copy files ..."
		ssh root@$2 mkdir /tmp/Atg
		scp adistro/arch_for_oracle/* root@$2:/tmp/Atg
	fi
fi	
}

if [[ $ipOfTargetHost == $ip_of_dbhost ]]
	then
	replasing adistro/template.json fake localhost nodes/"$ipOfTargetHost".json
	copy_files $ipOfTargetHost $ip_of_dbhost
	echo 'Start deploing by chef'
	deploy.sh root@$ipOfTargetHost
	else 
	replasing adistro/template.json oracle $ip_of_dbhost nodes/"$ipOfTargetHost".json
	replasing adistro/oracle_template.json fake $ip_of_dbhost nodes/"$ip_of_dbhost".json 
	copy_files $ipOfTargetHost $ip_of_dbhost
    echo 'Start deploing by chef'
	deploy.sh root@$ip_of_dbhost
	deploy.sh root@$ipOfTargetHost
fi 

echo
echo "Chef execution is complete!!!"  


echo -n "----- Would you like to start ATG publishing and production servers (y/N) :"
read start_servers_str
if [[ $start_servers_str == 'y' ]]
	then
    ssh root@$ipOfTargetHost /home/developer/run_pub_prod.sh
fi
echo
echo "Thank you"
echo
  