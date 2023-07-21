echo "---------TEST-----------"
echo $ENV_DESTRUCTIVE_DIFF

echo "-----LS before-----"
ls
sf project generate manifest --name destructiveChangesManifest $ENV_DESTRUCTIVE_DIFF --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"

echo "-----LS after-----"
ls
