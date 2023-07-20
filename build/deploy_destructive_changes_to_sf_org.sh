echo -e "--- Deploy destructive changes to Salesforce org script executions start ---\n\n\n"




echo -e "--- Step 1. Define global variables for the current pipeline ---\n"
echo "Step 1 execution result:"
echo "Global variables display"
echo -e "\nEvent type is:"
echo "Push"
echo -e "\nSource branch name is:"
echo $SOURCE_BRANCH_NAME
echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME
echo -e "\n---Step 1 execution is finished ---"




echo -e "\n\n\n--- Step 2. Define case for the current pipeline ---\n"
echo "Depends on the result of case definition the following will be determined:"
echo "A - Target Salesforce org for metadata"
echo -e "B - Salesforce org alias\n"
case $TARGET_BRANCH_NAME in
    "dev")
        CASE_LOG="dev"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_dev.org"
        ;;
    "qa")
        CASE_LOG="qa"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_qa.org"
        ;;
    "staging")
        CASE_LOG="staging"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_staging.org"
        ;;
    "uat")
        CASE_LOG="uat"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_uat.org"
        ;;
    "prod")
        CASE_LOG="prod"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_prod.org"
        ;;
    *)
        echo "Not valid"
        echo "Current target branch is not in the lis of avaliable branches (dev, qa, staging, uat, prod)"
        exit 1
        ;;
esac


echo "Step 2 execution result:"
echo -e "\nTarget Salesforce org for metadata is:"
echo $CASE_LOG
echo -e "\nSalesforce org alias is:"
echo $SALESFORCE_TARGET_ORG_ALIAS
echo -e "\n--- Step 2 execution is finished ---"






echo -e "\n\n\n--- Step 3. Define the list of desteuctive changes metadata---\n"
#DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME
DIFF_BRANCH="origin/"$SOURCE_BRANCH_NAME
GET_DESTRUCTIVE_DIFF=$(git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default)

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


echo "Step 3 execution result:"
echo -e "\nList of desteuctive changes metadata\n"
echo $SF_COMMAND_META_STRING
echo -e "\n--- Step 3 execution is finished ---"



echo -e "\n\n\n--- Step 4. Generate desteuctive changes metadata manifest---\n"
sf project generate manifest --name destructiveChangesManifest $SF_COMMAND_META_STRING --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
