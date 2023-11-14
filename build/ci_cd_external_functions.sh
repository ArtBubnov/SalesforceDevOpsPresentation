#!/bin/bash

logger () {
    echo -e "\n\n\n--- logger () function execution start. ---"
    echo -e "--- Output global info for the current pipeline ---\n"
    
    
    echo "Event is:"
    echo -e "Pull request\n"
    echo "Pull request source branch is:"
    echo $SOURCE_BRANCH_NAME
    echo -e "\nPull request target branch is:"
    echo $TARGET_BRANCH_NAME


    echo -e "\n--- logger () function execution end. ---\n"
}



# function to login to the target salesforce org
# via SFDX URL (ACCESS_KEY_SF variable)
# the SFDX URL is nested in Github actions env variables as an obfuscated variable
login_to_SF_org_short_version () {
    echo -e "\n\n\n--- login_to_SF_org_short_version () function execution start. ---"
    echo -e "--- Salesforce org login ---\n"


    #touch access_pass.key
    #echo $ACCESS_KEY_SF > access_pass.key
    #sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}
    #rm access_pass.key
    echo "PLACEHOLDER. SF org access granted"


    echo -e "\n--- login_to_SF_org_short_version () function execution end.\n ---"
}




login_to_SF_org_full_version () {
    echo -e "\n\n\n--- login_to_SF_org_full_version () function execution start. ---"
    echo -e "--- Login into Salesforce Org ---\n\n\n"



    echo -e "--- Step 1. Define global variables for the current pipeline ---\n\n"

    echo -e "Global variables display:"

    echo -e "\nTarget branch name is:"
    echo -e "PLACEHOLDER DEV"
    #echo $TARGET_BRANCH_NAME
    echo -e "\nSalesforce org alias is:"
    echo -e "PLACEHOLDER Salesforce org alias"
    #echo $SALESFORCE_ORG_ALIAS

    echo -e "\n\n--- Step 1 execution is finished ---"




    echo -e "\n\n\n--- Step 2. Login to the target Salesforce org"

    echo "Creating .key file"
    #touch access_pass.key

    echo -e "\nAdding access data to .key file"
    #echo $ACCESS_KEY_SF > access_pass.key

    echo -e "\nTry to login to the Salesforce org"
    #sf org login sfdx-url --sfdx-url-file "access_pass.key" --alias ${SALESFORCE_ORG_ALIAS}

    #rm access_pass.key

    echo -e "\n--- Step 2.  execution is finished"
}




