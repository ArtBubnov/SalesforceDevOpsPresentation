echo -e "--- Get destructive changes script executions start ---\n\n\n"


echo -e "--- Step 1. Define destructive changes ---\n"

DIFF_BRANCH="origin/qa"
mapfile -t files_array < <( git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default )


COUNT=0
ARRAY_LEN=${#files_array[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)
SF_COMMAND_META_STRING=""

while [ $COUNT -le $LOOP_LEN ]
do
    CURRENT_ARRAY_NODE=${files_array[$COUNT]}
    SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" '
    COUNT=$(( $COUNT +1))

done

echo "ENV_DESTRUCTIVE_DIFF=$SF_COMMAND_META_STRING" >> "$GITHUB_ENV"


echo -e "\nStep 1 execution result"
echo "destructive changes list is: "
echo $SF_COMMAND_META_STRING
echo -e "\n--- Step 1 execution is finished ---"




echo "----------TEST---------------"

#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
#sf project generate manifest --name destructiveChangesManifest --source-dir "force-app/main/default/objects/Account/fields/Business_Account__c.field-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
sfdx force:source:manifest:create --sourcepath "force-app/main/default/objects/Account/fieldSets/TACTUpdateFields.fieldSet-meta.xml" --manifestname zhopaManifest

