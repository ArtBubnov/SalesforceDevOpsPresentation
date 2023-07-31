echo -e "\n\n\nSalesforce CLI version check\n"
sudo npm sfdx --version

echo "---------TEST----------"
#works if deploy is needed
#sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --target-org $SALESFORCE_ORG_ALIAS --test-level NoTestRun


#sf project deploy report --use-most-recent
#sf project deploy report --job-id "0Af5j00000TcKLhCAN" -u ${SALESFORCE_ORG_ALIAS}
#deploy_id="0Af5j00000TcKLhCAN"
#sf project deploy report --job-id $deploy_id --dev-debug

#sfdx force:mdapi:deploy:report --jobid "0Af5j00000TcKLhCAN" -u ${SALESFORCE_ORG_ALIAS}

#0Af5j00000SwqOb - bad
#0Af5j00000TcKLhCAN - good




#--dry-run - test run without saving 
SALESFORCE_DEPLOY_LOG=$(sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --dry-run --test-level NoTestRun --target-org ${SALESFORCE_ORG_ALIAS})


mapfile -t SALESFORCE_DEPLOY_LOG_ARRAY < <( echo $SALESFORCE_DEPLOY_LOG | tr ' ' '\n' | sed 's/\(.*\),/\1 /' )

echo "--------- DEPLOY TEST ------------"
echo $TEST
echo ARRAY_LEN=${#SALESFORCE_DEPLOY_LOG_ARRAY[@]}

echo "--------- ARRAY TEST ---------"
echo $ARRAY_LEN
echo "--------- ARRAY ITEM TEST ---------"
echo ${SALESFORCE_DEPLOY_LOG_ARRAY[0]}



COUNT=0
ARRAY_LEN=${#SALESFORCE_DEPLOY_LOG[@]}
SALESFORCE_DEPLOY_ID=""
LOOP_LEN=$( expr $ARRAY_LEN - 1)

while [ $COUNT -le $LOOP_LEN ]
do
    echo "----"${SALESFORCE_DEPLOY_LOG[$COUNT]}"----"
    if [[ ${SALESFORCE_DEPLOY_LOG[$COUNT]} == *"ID:"* ]];
    then
        echo "TRUE"
        SALESFORCE_DEPLOY_ID_ARRAY_POSITION=$(( $COUNT +1))
        SALESFORCE_DEPLOY_ID=${SALESFORCE_DEPLOY_LOG[$SALESFORCE_DEPLOY_ID_ARRAY_POSITION]}
    else   
        echo "FALSE"
    fi
COUNT=$(( $COUNT +1))
done

echo "--------- SALESFORCE_DEPLOY_ID ------------"
echo $SALESFORCE_DEPLOY_ID




#    if [[ ${classes_files_array[$COUNT]} == *"Test.cls"* ]];
#    then

#        if [[ ${classes_files_array[$COUNT]} == *"cls-meta.xml"* ]];
#        then
#            LIST_OF_XML_FILES=$LIST_OF_XML_FILES{classes_files_array[$COUNT]}","
#        else
#            LEN_OF_FILE_NAME=${#classes_files_array[$COUNT]}
#            NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_FILE_NAME - 4 )
#            FILE_NAME_TRUNC=$((echo ${classes_files_array[$COUNT]}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )
#            LIST_OF_FILES_TO_TEST=$LIST_OF_FILES_TO_TEST$FILE_NAME_TRUNC","
#        fi#

#    fi 
#    COUNT=$(( $COUNT +1))















#--source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml"


#sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN
