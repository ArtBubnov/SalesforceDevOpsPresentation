echo "---------TEST-----------"
echo $SF_COMMAND_META_STRING

echo "-----LS before-----"
ls
#sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"

#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/object/Account/fields/Business_Account__c.field-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"




#echo "-----LS after-----"
#ls
