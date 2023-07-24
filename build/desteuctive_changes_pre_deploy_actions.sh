echo "---------TEST-----------"
echo $ENV_DESTRUCTIVE_DIFF

echo "-----LS before-----"
ls
#sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"

#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/object/Account/fields/Business_Account__c.field-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"


sfdx force:source:manifest:create $SF_COMMAND_META_STRING --manifestname zhopaManifest

echo "-----LS after-----"
ls
