#!/bin/bash

echo "----------------------------------------------------------------"
echo "                         $0"
echo "                         $1"
echo "----------------------------------------------------------------"

export BATCH_FILE_FOR_CIM=$1

$DYNAMO_HOME/bin/cim.sh -batch $BATCH_FILE_FOR_CIM

EXIT_CODE=$?

if [[ $EXIT_CODE = 1 ]]
    then
    if (( "$STOP_POINT_FOR_CIM" < 5 ))
        then
        echo "+++              STOP_POINT = $STOP_POINT_FOR_CIM         +++"
        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
		echo "Cim was faild in this stage, run again !!!!!!"
		echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
		echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
		STOP_POINT_FOR_CIM=$( expr "$STOP_POINT_FOR_CIM" + 1 )
		echo "---              STOP_POINT = $STOP_POINT_FOR_CIM         ---"
		$0 $BATCH_FILE_FOR_CIM
    else
		echo
		echo "CRITICAL ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "CRITICAL ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "CRITICAL ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit 167
	fi
else
    echo SUCCESS
    exit 0
fi



		