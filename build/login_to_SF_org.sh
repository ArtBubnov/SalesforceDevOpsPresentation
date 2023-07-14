echo -e "Logging into Salesforce Org\n\n\n"




echo "Step 1. Define global variables for the current pipeline"
TARGET_BRANCH_NAME=$GITHUB_BASE_REF
echo "Step 1 execution is finished"
echo "Step 1 execution result:"
echo "Target branch is:"
echo $TARGET_BRANCH_NAME=$GITHUB_BASE_REF