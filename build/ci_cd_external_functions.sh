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
    SF_COMMAND_META_STRING="--source-dir "

    if [[ $ARRAY_LEN != 0 ]]
        then
            while [ $COUNT -le $LOOP_LEN ]
            do
                CURRENT_ARRAY_NODE=${files_array[$COUNT]}
                #SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" ' 
                SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}'"'${CURRENT_ARRAY_NODE}'" '
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
    echo -e "--- Predeploy actions script executions start ---\n\n\n"
    HOME_DIR=$(pwd)





    echo -e "\n\n\n--- Step 2. Logic execution to define the list of apex tests to be executed during deployment to the Salesforce org ---"

    #get to classes directory to define the list of tests to be executed
    cd $APEX_TESTS_DIRECTORY

    #add all the files in the folder into array
    mapfile -t classes_files_array < <( ls )

    #define which of the files are tests
    COUNT=0
    ARRAY_LEN=${#classes_files_array[@]}
    LIST_OF_FILES_TO_TEST=""
    LOOP_LEN=$( expr $ARRAY_LEN - 1)

    while [ $COUNT -le $LOOP_LEN ]
    do
        if [[ ${classes_files_array[$COUNT]} == *"Test.cls"* ]];
        then

            if [[ ${classes_files_array[$COUNT]} == *"cls-meta.xml"* ]];
            then
                LIST_OF_XML_FILES=$LIST_OF_XML_FILES{classes_files_array[$COUNT]}","
            else
                LEN_OF_FILE_NAME=${#classes_files_array[$COUNT]}
                NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_FILE_NAME - 4 )
                FILE_NAME_TRUNC=$((echo ${classes_files_array[$COUNT]}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )
                LIST_OF_FILES_TO_TEST=$LIST_OF_FILES_TO_TEST$FILE_NAME_TRUNC","
            fi

        fi 
        COUNT=$(( $COUNT +1))
    done

    LEN_OF_LIST_OF_FILES_TO_TEST=${#LIST_OF_FILES_TO_TEST}
    NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_LIST_OF_FILES_TO_TEST - 1 )
    LIST_OF_FILES_TO_TEST_TRUNC=$((echo ${LIST_OF_FILES_TO_TEST}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )


    echo -e "\nStep 2 execution result:"
    echo -e "\nList of apex tests to be executed:"
    echo $LIST_OF_FILES_TO_TEST_TRUNC
    cd $HOME_DIR

    echo -e "\n--- Step 2 execution is finished ---"




    echo -e "\n\n\n--- Step 3. Test deploy to the Salesforce org ---\n"

    #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN
    #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l NoTestRun -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN
    sfdx force:source:deploy -p "$ENV_POSITIVE_DIFF_SF" -c -l NoTestRun -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN


    echo -e "\n--- Step 3 execution is finished ---"
}