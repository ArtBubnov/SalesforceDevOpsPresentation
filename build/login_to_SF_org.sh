echo -e "Logging into Salesforce Org\n\n\n"



echo -e "--- Step 1. Define global variables for the current pipeline ---\n\n"

echo -e "Global variables display:\n"
echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME

echo -e "\n\n--- Step 1 execution is finished ---"




echo -e "\n\n\nStep 2. Define case for the current pipeline"
echo "Depends on the result of case definition the following will be determined:"
echo "A - Salesforce access key (AUTH URL)"
echo "B - Salesforce org alias"

case $TARGET_BRANCH_NAME in
    "dev")
        CASE_LOG="dev"
        #ACCESS_KEY_SF_DEV stored as GitHub secret variable
        ACCESS_KEY_SF=$ACCESS_KEY_SF_DEV
        SALESFORCE_ORG_ALIAS="salesforce_dev.org"
        ;;
    "qa")
        CASE_LOG="qa"
        #ACCESS_KEY_SF_QA stored as GitHub secret variable
        ACCESS_KEY_SF=$ACCESS_KEY_SF_DEV
        SALESFORCE_ORG_ALIAS="salesforce_qa.org"
        ;;
    "uat")
        CASE_LOG="uat"
        #ACCESS_KEY_SF_UAT stored as GitHub secret variable
        ACCESS_KEY_SF=$ACCESS_KEY_SF_DEV
        SALESFORCE_ORG_ALIAS="salesforce_uat.org"
        ;;
    "staging")
        CASE_LOG="staging"
        #ACCESS_KEY_SF_STAGING stored as GitHub secret variable
        ACCESS_KEY_SF=$ACCESS_KEY_SF_DEV
        SALESFORCE_ORG_ALIAS="salesforce_staging.org"        
        ;;
    "prod")
        CASE_LOG="prod"
        #ACCESS_KEY_SF_PROD stored as GitHub secret variable
        ACCESS_KEY_SF=$ACCESS_KEY_SF_DEV
        SALESFORCE_ORG_ALIAS="salesforce_prod.org"
        ;;
    *)
        echo "Not valid"
        echo "Target branch is not in the list (dev, qa, uat, staging, prod)"
        echo "Target branch name is:"
        echo $TARGET_BRANCH_NAME
        ;;
esac

echo "Step 2 execution is finished"
echo "Step 2 execution result:"
echo "Case result:"
echo $CASE_LOG
echo "Salesforce org to be used:"
echo $CASE_LOG
echo "Salesforce alias to be used: "
echo $SALESFORCE_ORG_ALIAS
echo "TESTS-------TESTS"
echo $ACCESS_KEY_SF


echo -e "\n\n\nStep 3. Login to the target Salesforce org"
echo "Creating .key file"
touch access_pass.key

echo -e "\nAdding access data to .key file"
echo $ACCESS_KEY_SF > access_pass.key

echo -e "\nTry SF login"
echo "-----TEST----"
sfdx force:auth:sfdxurl:store -f "access_pass.key" -a ${SALESFORCE_ORG_ALIAS} -d
#sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}
rm access_pass.key
echo -e "--- Step 3.  execution is finished"