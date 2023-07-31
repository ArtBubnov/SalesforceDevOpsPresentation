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
SALESFORCE_DEPLOYMENT_STATUS_INFO=$(sfdx force:mdapi:deploy:report --jobid "0Af5j00000SwqOb" -u ${SALESFORCE_ORG_ALIAS})

echo "-----------------SFDX-------------"
echo $SALESFORCE_DEPLOYMENT_STATUS_INFO



if [[ $SALESFORCE_DEPLOYMENT_STATUS_INFO == *"Succeeded Deployed"* ]];
then
   echo "DEPLOY PASSED" 
else
    echo "DEPLOY FAILED"
fi