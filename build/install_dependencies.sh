echo -e "\n\n\nSalesforce CLI version check\n"
sudo npm sfdx --version

echo "---------TEST----------"
sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --target-org $SALESFORCE_ORG_ALIAS --test-level NoTestRun


#sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN

#sf project delete source --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --check-only --target-org ${SALESFORCE_ORG_ALIAS} --no-prompt

#cd -- "$dirName"