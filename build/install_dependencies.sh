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
echo SALESFORCE_DEPLOY_LOG

mapfile -t SALESFORCE_DEPLOY_LOG_ARRAY < <( echo $SALESFORCE_DEPLOY_LOG | tr ' ' '\n' | sed 's/\(.*\),/\1 /' )


COUNT=0
ARRAY_LEN=${#SALESFORCE_DEPLOY_LOG_ARRAY[@]}
SALESFORCE_DEPLOY_ID=""
LOOP_LEN=$( expr $ARRAY_LEN - 1)

while [ $COUNT -le $LOOP_LEN ]
do
    if [[ ${SALESFORCE_DEPLOY_LOG_ARRAY[$COUNT]} == *"ID:"* ]];
    then
        SALESFORCE_DEPLOY_ID_ARRAY_POSITION=$(( $COUNT +1))
        SALESFORCE_DEPLOY_ID=${SALESFORCE_DEPLOY_LOG_ARRAY[$SALESFORCE_DEPLOY_ID_ARRAY_POSITION]}
        COUNT=$(( $COUNT +1))
    else   
        COUNT=$(( $COUNT +1))
    fi
done

echo "--------- SALESFORCE_DEPLOY_ID ------------"
echo $SALESFORCE_DEPLOY_ID


echo "--------- SALESFORCE_DEPLOYMENT_STATUS_INFO ------------"
SALESFORCE_DEPLOYMENT_STATUS_INFO=$(sfdx force:mdapi:deploy:report --jobid ${SALESFORCE_DEPLOY_ID} -u ${SALESFORCE_ORG_ALIAS})
echo $SALESFORCE_DEPLOYMENT_STATUS_INFO















#--source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml"


#sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN
