#!/bin/bash

source /etc/init.d/flags.sh

run_cim(){
	if [[ ! $1 == 0 ]]
	then
		echo
		echo "###################################"
		echo "#  Run $2"
		echo "###################################"
		echo
		for ATTEMPT in `seq 1 5`;
		do
			echo "-------------ATTEMPT = $ATTEMPT"
			$DYNAMO_HOME/bin/cim.sh -batch /home/developer/$2
			EXIT_CODE=$?
			if [[ $EXIT_CODE != 0 ]]
			then
				if (( "$ATTEMPT" > 4 ))
				then
					echo "CRITICAL ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
					echo "For more information look to ATG_HOME/CIM/log/cim.log"
					exit 222
				else
					echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
					echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
					echo "Cim was faild in this stage, run again !!!!!!"
					echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
					echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
				fi
			else
				echo ""
				echo ":) :) :) :) :) :) :) :) :) :) :) :) :)"
				echo " Cim successfully completed this level"
				echo "export $1=0" >> /etc/init.d/flags.sh
				break
			fi
		done
	fi
}

echo '<<<<<<<<<<<<<<<<<<<<<'
echo "Run cim in batch mode!!!!"
echo '<<<<<<<<<<<<<<<<<<<<<'

run_cim CIM_PROD_SELECT_FLAG prod_select_batch.cim
run_cim CIM_SERVER_SETUP_FLAG server_setup_batch.cim
run_cim CIM_CREATE_PUB_SCHEMA create_pub_schema_batch.cim
run_cim CIM_IMPORT_PUB_DATA import_pub_data_batch.cim
run_cim CIM_CREATE_A_SCHEMA create_a_schema_batch.cim
run_cim CIM_IMPORT_A_DATA import_a_data_batch.cim
run_cim CIM_CREATE_B_SCHEMA create_b_schema_batch.cim
run_cim CIM_IMPORT_B_DATA import_b_data_batch.cim
run_cim CIM_CREATE_CORE_SCHEMA create_core_schema_batch.cim
run_cim CIM_IMPORT_CORE_DATA import_core_data_batch.cim
run_cim CIM_OTHER_TASKS other_tasks_batch.cim
