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



echo "-----------TEST--------"
pwd