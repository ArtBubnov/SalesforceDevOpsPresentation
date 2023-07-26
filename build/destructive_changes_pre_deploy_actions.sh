echo -e "--- Get destructive changes script executions start ---\n\n\n"


echo -e "--- Step 1. Define destructive changes ---\n"

echo $ENV_DESTRUCTIVE_DIFF_SF
#echo $ENV_DESTRUCTIVE_DIFF_SFDX 

echo "-----LS before-----"
ls
#sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
# 
#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/object/Account/fields/Business_Account__c.field-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"


#sfdx force:source:manifest:create $ENV_DESTRUCTIVE_DIFF_SFDX --manifestname zhopaManifest
# 

#sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF_SF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
echo "---------TEST-----------"
echo "Creating .key file"
touch access_pass.key

echo -e "\nAdding access data to .key file"
echo $DEV_SALESFORCE_AUTH_GITHUB_SECRET_VALUE > access_pass.key
SALESFORCE_ORG_ALIAS="salesforce_dev.org"

echo -e "\nTry SF login"
sfdx force:auth:sfdxurl:store -f "access_pass.key" -a ${SALESFORCE_ORG_ALIAS} -d
rm access_pass.key

sf project delete source $ENV_DESTRUCTIVE_DIFF_SF --target-org ${SALESFORCE_ORG_ALIAS} --no-prompt