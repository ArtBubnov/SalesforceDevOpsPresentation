echo -e "Logging into Salesforce Org\n\n\n"




#echo "Step 1. Define global variables for the current pipeline"
#TARGET_BRANCH_NAME=${{ github.event.pull_request.base.ref }}
#echo "Step 1 execution is finished"
#echo "Step 1 execution result:"
#echo "Target branch is:"
#echo $TARGET_BRANCH_NAME


echo -e "--- Step 1. Define global variables for the current pipeline ---\n"

SOURCE_BRANCH_NAME=$GITHUB_HEAD_REF
TARGET_BRANCH_NAME=$GITHUB_BASE_REF
echo -e "Global variables display:\n"
echo "Event type is:"
echo -e "Pull request\n"
echo "Source branch name is:"
echo $SOURCE_BRANCH_NAME
echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME
echo "----"
echo $TEST

echo -e "\n--- Step 1 execution is finished ---"