#!/bin/bash

# function to login to the target salesforce org
# via SFDX URL (ACCESS_KEY_SF variable)
# the SFDX URL is nested in Github actions env variables as an obfuscated variable
login_to_SF_org_short_version () {
    #touch access_pass.key
    #echo $ACCESS_KEY_SF > access_pass.key
    #sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}
    #rm access_pass.key
    echo "PLACEHOLDER. SF org access granted"
}




login_to_SF_org_full_version () {
    echo -e "--- Logging into Salesforce Org ---\n\n\n"



    echo -e "--- Shell script | Step 1. Define global variables for the current pipeline ---\n\n"

    echo -e "Global variables display:"

    echo -e "\nTarget branch name is:"
    echo -e "PLACEHOLDER DEV"
    #echo $TARGET_BRANCH_NAME
    echo -e "\nSalesforce org alias is:"
    echo -e "PLACEHOLDER Salesforce org alias"
    #echo $SALESFORCE_ORG_ALIAS

    echo -e "\n\n--- Shell script | Step 1 execution is finished ---"




    echo -e "\n\n\n--- Shell script | Step 2. Login to the target Salesforce org"

    echo "Creating .key file"
    #touch access_pass.key

    echo -e "\nAdding access data to .key file"
    #echo $ACCESS_KEY_SF > access_pass.key

    echo -e "\nTry to login to the Salesforce org"
    #sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}

    #rm access_pass.key

    echo -e "\n--- Shell script | Step 2.  execution is finished"
}




define_destructive_changes_full_version () {
    echo "--- Define positive and destructive changes script execution start ---\n"
}







#test_02 () {
#   echo -e "TEST_02"
#}