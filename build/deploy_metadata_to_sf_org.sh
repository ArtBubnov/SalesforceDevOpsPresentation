echo -e "--- Deploy metadata to Salesforce org script executions start ---\n\n\n"




echo -e "--- Step 1. Define global variables for the current pipeline ---\n"

echo "Step 1 execution result:"
echo "Global variables display"
echo -e "\nEvent type is:"
echo "Push"
echo -e "\nSource branch name is:"
echo $SOURCE_BRANCH_NAME
echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME
echo -e "\nSalesforce org alias is:"
echo $SALESFORCE_ORG_ALIAS

echo -e "\n---Step 1 execution is finished ---"




echo -e "\n\n\n--- Step 2. Logic execution to define the list of files to be deployed to the Salesforce org ---"

echo -e "\nFind the difference between organizations"
DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

echo -e "\nDiff logic execution result:"
GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY})

echo $GET_DIFF
FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY} | tr '\n' ',' | sed 's/\(.*\),/\1 /')


echo -e "\nStep 2 execution is finished"
echo "Step 3 execution result:"
echo -e "\nFiles to deploy"
echo $FILES_TO_DEPLOY

echo -e "\n--- Step 2 execution is finished ---"




echo -e "\n\n\n--- Step 3. Deploy data to the target Salesforce org ----"

sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN

echo "--- Step 3 execution is finished ---"