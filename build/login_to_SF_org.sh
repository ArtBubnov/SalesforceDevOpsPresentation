echo -e "--- Logging into Salesforce Org ---\n\n\n"



echo -e "--- Step 1. Define global variables for the current pipeline ---\n\n"

echo -e "Global variables display:"

echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME
echo -e "\nSalesforce org alias is:"
echo $SALESFORCE_ORG_ALIAS

echo -e "\n\n--- Step 1 execution is finished ---"




echo -e "\n\n\nStep 2. Login to the target Salesforce org"

echo "Creating .key file"
touch access_pass.key

echo -e "\nAdding access data to .key file"
echo $ACCESS_KEY_SF > access_pass.key

echo -e "\nTry to login to the Salesforce org"
sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}

rm access_pass.key

echo -e "\n--- Step 2.  execution is finished"








echo "------------- TEST ------------"
mapfile -t POSITIVE_DIFF_ARRAY < <( git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY} )



COUNT=0
ARRAY_LEN=${#POSITIVE_DIFF_ARRAY[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)
SF_COMMAND_META_STRING=""


while [ $COUNT -le $LOOP_LEN ]
do
    CURRENT_ARRAY_NODE=${POSITIVE_DIFF_ARRAY[$COUNT]}
    FILES_TO_DEPLOY=${FILES_TO_DEPLOY}'"'${CURRENT_ARRAY_NODE}'" '  
    COUNT=$(( $COUNT +1))
done


echo -e "\nStep 2 execution is finished"
echo "Step 2 execution result:"
echo -e "\nFiles to deploy"
echo $FILES_TO_DEPLOY

echo "TEST_FILES_TO_DEPLOY=$FILES_TO_DEPLOY" >> "$GITHUB_ENV"

echo -e "\n--- Step 2 execution is finished ---"