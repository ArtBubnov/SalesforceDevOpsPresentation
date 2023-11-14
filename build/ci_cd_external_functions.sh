#!/bin/bash

logger () {
    echo -e "--- logger () function execution start. ---"
    echo -e "--- Output global info for the current pipeline ---\n"
    
    
    echo "Event is:"
    echo -e "Pull request\n"
    echo "Pull request source branch is:"
    echo $SOURCE_BRANCH_NAME
    echo -e "\nPull request target branch is:"
    echo $TARGET_BRANCH_NAME
    echo -e "\nInstalled SFDX version is:"
    sudo npm sfdx --version


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




get_positive_changes () {
    echo -e "--- get_positive_changes () function execution start. ---"
    echo -e "--- Define positive changes ---\n"



    echo -e "\n\n\n--- Step 1. Logic execution to define the list of POSITIVE files to be deployed to the Salesforce org ---"


    echo -e "\nFind the difference between organizations"
    DIFF_SOURCE_BRANCH="origin/"$SOURCE_BRANCH_NAME
    DIFF_TARGET_BRANCH="origin/"$TARGET_BRANCH_NAME

    echo -e "\nDiff logic execution result:"
    GET_DIFF=$(git diff ${DIFF_SOURCE_BRANCH}..${DIFF_TARGET_BRANCH} --name-only --diff-filter=ACMR ${SALESFORCE_META_DIRECTORY})

    echo $GET_DIFF
    FILES_TO_DEPLOY=$(git diff ${DIFF_SOURCE_BRANCH}..${DIFF_TARGET_BRANCH} --name-only --diff-filter=ACMR ${SALESFORCE_META_DIRECTORY} | tr '\n' ',' | sed 's/\(.*\),/\1 /')


    echo -e "\nStep 1 execution is finished"
    echo "Step 1 execution result:"
    echo -e "\nFiles to deploy"
    echo $FILES_TO_DEPLOY
    echo "ENV_POSITIVE_DIFF_SF=$FILES_TO_DEPLOY" >> "$GITHUB_ENV"


    echo -e "\n--- Step 1 execution is finished ---\n\n\n"
}




get_destructive_changes () {
    echo -e "--- get_destructive_changes () function execution start. ---"
    echo -e "--- Define destructive changes ---\n"



    echo -e "\n\n\n--- Step 1. Logic execution to define the list of DESTRUCTIVE files to be deleted from the Salesforce org ---"


    echo -e "\nFind the difference between organizations"
    DIFF_SOURCE_BRANCH="origin/"$SOURCE_BRANCH_NAME
    DIFF_TARGET_BRANCH="origin/"$TARGET_BRANCH_NAME

    echo -e "\nDiff logic execution result:"
    GET_DIFF=$(git diff ${DIFF_SOURCE_BRANCH}..${DIFF_TARGET_BRANCH} --name-only --diff-filter=D ${SALESFORCE_META_DIRECTORY})

    echo $GET_DIFF
    FILES_TO_DEPLOY=$(git diff ${DIFF_SOURCE_BRANCH}..${DIFF_TARGET_BRANCH} --name-only --diff-filter=D ${SALESFORCE_META_DIRECTORY} | tr '\n' ',' | sed 's/\(.*\),/\1 /')

    mapfile -t files_array < <( git diff ${DIFF_SOURCE_BRANCH}..${DIFF_TARGET_BRANCH} --name-only --diff-filter=D ${SALESFORCE_META_DIRECTORY} )

    COUNT=0
    ARRAY_LEN=${#files_array[@]}
    LOOP_LEN=$( expr $ARRAY_LEN - 1)
    SF_COMMAND_META_STRING=""

    if [[ $ARRAY_LEN != 0 ]]
        then
            while [ $COUNT -le $LOOP_LEN ]
            do
                CURRENT_ARRAY_NODE=${files_array[$COUNT]}
                SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" '    
                COUNT=$(( $COUNT +1))

            done

            echo "ENV_DESTRUCTIVE_DIFF_SF=$SF_COMMAND_META_STRING" >> "$GITHUB_ENV"
            echo "DESTRUCTIVE_CHANGES_PRESENTED=true" >> "$GITHUB_ENV"

            echo -e "\nStep 2 execution result"
            echo "destructive changes list is: "
            echo $SF_COMMAND_META_STRING
            echo -e "\n--- Step 2 execution is finished ---"
        else
            echo "Due to there are no destructive changes detected"
            echo -e "Script exection will be finished with 0 code status\n"
            echo "The workflow execution will be proceeded"
            echo -e "\n--- Step 2 execution is finished ---"
            echo "DESTRUCTIVE_CHANGES_PRESENTED=false" >> "$GITHUB_ENV"
    fi
}






destructive_changes_pre_deploy_actions () {
    echo -e "--- Deploy destructive changes script executions start ---\n\n\n"


    echo -e "--- Step 1. Deploy destructive changes without saving ---\n"

    if [[ $DESTRUCTIVE_CHANGES_PRESENTED == true ]]
        then
            sf project delete source $ENV_DESTRUCTIVE_DIFF_SF -с --target-org ${SALESFORCE_ORG_ALIAS} --no-prompt

            echo -e "\n\n--- Step 1 execution is finished ---"
        else
            echo "Due to there are no destructive changes detected"
            echo -e "Script exection will be finished with 0 code status\n"
            echo "The workflow execution will be proceeded"

            echo -e "\n--- Step 1 execution is finished ---"
            exit 0
    fi
}




positive_changes_pre_deploy_actions () {

    echo "test"
}






#test () {
#    #GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY})
#
#    GET_DIFF=$(git diff dev..qa --name-only --diff-filter=ACMRD force-app/main/default)


    #GET_DIFF=$(git branch)
#    echo -e "*******"
#    echo -e $GET_DIFF
#    echo -e "*******"
#}



test (FLAG) {
    echo "Первый параметр: $FLAG"
}