echo -e "Logging into Salesforce Org\n\n\n"



echo -e "--- Step 1. Define global variables for the current pipeline ---\n\n"

echo -e "Global variables display:\n"

echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME
echo $ACCESS_KEY_SF_DEV
echo $SALESFORCE_ORG_ALIAS

echo -e "\n\n--- Step 1 execution is finished ---"



echo -e "\n\n\nStep 2. Login to the target Salesforce org"
echo "Creating .key file"
touch access_pass.key

echo -e "\nAdding access data to .key file"
echo $ACCESS_KEY_SF > access_pass.key

echo -e "\nTry SF login"
echo "-----TEST----"
#sfdx force:auth:sfdxurl:store -f "access_pass.key" -a ${SALESFORCE_ORG_ALIAS} -d
sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}
rm access_pass.key
echo -e "--- Step 3.  execution is finished"