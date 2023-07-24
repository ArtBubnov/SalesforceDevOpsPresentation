echo "---------TEST-----------"
echo $ENV_DESTRUCTIVE_DIFF_SF
#echo $ENV_DESTRUCTIVE_DIFF_SFDX

echo "-----LS before-----"
ls
#sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
#
#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/object/Account/fields/Business_Account__c.field-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"


#sfdx force:source:manifest:create $ENV_DESTRUCTIVE_DIFF_SFDX --manifestname zhopaManifest
#

sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF_SF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
echo "-----LS after-----"
ls
