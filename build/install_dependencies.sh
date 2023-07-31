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
TEST=$(sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --dry-run --test-level NoTestRun --target-org ${SALESFORCE_ORG_ALIAS})

mapfile -t SALESFORCE_DEPLOY_LOG < <( echo $TEST )

echo "--------- DEPLOY TEST ------------"
echo $TEST
#echo ARRAY_LEN=${#SALESFORCE_DEPLOY_LOG[@]}

#echo "--------- ARRAY TEST ---------"
#echo $ARRAY_LEN
#echo "--------- ARRAY ITEM TEST ---------"
#echo ${SALESFORCE_DEPLOY_LOG[0]}

















#--source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml"


#sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN
