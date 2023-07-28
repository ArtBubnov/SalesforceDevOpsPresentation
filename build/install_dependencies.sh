echo -e "\n\n\nSalesforce CLI version check\n"
sudo npm sfdx --version

echo "---------TEST----------"
#works if deploy is needed
#sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --target-org $SALESFORCE_ORG_ALIAS --test-level NoTestRun


echo $PR_NUMBER

