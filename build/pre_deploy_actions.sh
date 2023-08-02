echo -e "--- Predeploy actions script executions start ---\n\n\n"

echo "-------- test-------"
HOME_DIR=$(pwd)
ls
cd force-app/main/default/classes
echo "-----------"
ls
cd $HOME_DIR
echo "-------- test-----"

echo -e "--- Step 1. Define global variables for the current pipeline ---\n"

echo -e "Global variables display:\n"
echo "Event type is:"
echo -e "Pull request\n"
echo "Source branch name is:"
echo $SOURCE_BRANCH_NAME
echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME
echo -e "\nSalesforce org alias is:"
echo $SALESFORCE_ORG_ALIAS

HOME_DIR=$(pwd)

echo -e "\n--- Step 1 execution is finished ---"





echo -e "\n\n\n--- Step 2. Logic execution to define the list of files to be deployed to the Salesforce org ---"

echo -e "\nFind the difference between organizations"
DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

echo -e "\nDiff logic execution result:"
GET_DIFF_LOGGER=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY})

echo $GET_DIFF_LOGGER


#mapfile -t files_array < <( git diff --name-only --diff-filter=D ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY} )
mapfile -t POSITIVE_DIFF_ARRAY < <( git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} ${SALESFORCE_META_DIRECTORY} )



COUNT=0
ARRAY_LEN=${#POSITIVE_DIFF_ARRAY[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)
SF_COMMAND_META_STRING=""


while [ $COUNT -le $LOOP_LEN ]
do
    CURRENT_ARRAY_NODE=${POSITIVE_DIFF_ARRAY[$COUNT]}
    FILES_TO_DEPLOY=${FILES_TO_DEPLOY}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" ' 
    #FILES_TO_DEPLOY=${FILES_TO_DEPLOY}'"'${CURRENT_ARRAY_NODE}'" '  
    COUNT=$(( $COUNT +1))
done
#"--source-dir "'"'${CURRENT_ARRAY_NODE}'" ' 

echo -e "\nStep 2 execution is finished"
echo "Step 2 execution result:"
echo -e "\nFiles to deploy"
echo $FILES_TO_DEPLOY

echo "TEST_FILES_TO_DEPLOY=$FILES_TO_DEPLOY" >> "$GITHUB_ENV"

echo "-----test-----"
echo $TEST_FILES_TO_DEPLOY

echo -e "\n--- Step 2 execution is finished ---"




#echo -e "\n\n\n--- Step 3. Logic execution to define the list of apex tests to be executed during deployment to the Salesforce org ---"

##get to classes directory to define the list of tests to be executed
#cd $APEX_TESTS_DIRECTORY

#add all the files in the folder into array
#mapfile -t classes_files_array < <( ls )

#define which of the files are tests
#COUNT=0
#ARRAY_LEN=${#classes_files_array[@]}
#LIST_OF_FILES_TO_TEST=""
#LOOP_LEN=$( expr $ARRAY_LEN - 1)

#while [ $COUNT -le $LOOP_LEN ]
#do
#    if [[ ${classes_files_array[$COUNT]} == *"Test.cls"* ]];
#    then

#        if [[ ${classes_files_array[$COUNT]} == *"cls-meta.xml"* ]];
#        then
#            LIST_OF_XML_FILES=$LIST_OF_XML_FILES{classes_files_array[$COUNT]}","
#        else
#            LEN_OF_FILE_NAME=${#classes_files_array[$COUNT]}
#            NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_FILE_NAME - 4 )
#            FILE_NAME_TRUNC=$((echo ${classes_files_array[$COUNT]}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )
#            LIST_OF_FILES_TO_TEST=$LIST_OF_FILES_TO_TEST$FILE_NAME_TRUNC","
#        fi

#    fi 
#    COUNT=$(( $COUNT +1))
#done

#LEN_OF_LIST_OF_FILES_TO_TEST=${#LIST_OF_FILES_TO_TEST}
#NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_LIST_OF_FILES_TO_TEST - 1 )
#LIST_OF_FILES_TO_TEST_TRUNC=$((echo ${LIST_OF_FILES_TO_TEST}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )


#echo -e "\nStep 3 execution result:"
#echo -e "\nList of apex tests to be executed:"
#echo $LIST_OF_FILES_TO_TEST_TRUNC
#cd $HOME_DIR

#echo -e "\n--- Step 3 execution is finished ---"




echo -e "\n\n\n--- Step 4. Test deploy to the Salesforce org ---\n"

#sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN
#sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l NoTestRun -u ${SALESFORCE_ORG_ALIAS} --loglevel WARN


#TEST="force-app/main/default/classes/CreatingAccount1.cls"
#sf project deploy start --dry-run $FILES_TO_DEPLOY --target-org ${SALESFORCE_ORG_ALIAS} --test-level NoTestRun
#sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" --source-dir "force-app/main/default/classes/CreatingAccount2.cls" --source-dir "force-app/main/default/classes/CreatingAccount2.cls-meta.xml" --source-dir "force-app/main/default/classes/CreatingAccount3.cls" --source-dir "force-app/main/default/classes/CreatingAccount3.cls-meta.xml" --target-org ${SALESFORCE_ORG_ALIAS} --test-level NoTestRun --dry-run
#sf project deploy start --source-dir "force-app/main/default/classes/CreatingAccount1.cls" "force-app/main/default/classes/CreatingAccount2.cls" --target-org ${SALESFORCE_ORG_ALIAS} --test-level NoTestRun --dry-run
sf project deploy start "$FILES_TO_DEPLOY" --target-org ${SALESFORCE_ORG_ALIAS} --test-level NoTestRun --dry-run



echo -e "\n--- Step 4 execution is finished ---"