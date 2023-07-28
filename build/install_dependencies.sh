echo -e "\n\n\nSalesforce CLI version check\n"
sudo npm sfdx --version

echo "---------TEST----------"

sf project delete source --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount1.cls-meta.xml" --check-only --target-org ${SALESFORCE_ORG_ALIAS} --no-prompt

#cd -- "$dirName"