echo -e "--- Deploy metadata to Salesforce org script executions start ---\n\n\n"




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




#-------------------------------
echo -e "\n\n\n--- Step 3.1. Logic execution to define the list of files to be deleted from the Salesforce org ---\n"

echo -e "Find the DESTRUCTIVE difference between organizations\n"
DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

GET_DESTRUCTIVE_DIFF=$(git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default)
#echo $GET_DESTRUCTIVE_DIFF

DESTRUCTIVE_FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')




echo "LS BEFORE"
pwd
ls
echo "********"
echo "********"
echo "********"

#sfdx force:source:manifest:create --name destructiveChangesManifest --metadata "DLT_CaseBatch.cls,DLT_SubscriptionBatch.cls" -d "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
#sfdx force:source:manifest:create --name destructiveChangesManifest --metadata --array-flag DLT_CaseBatch.cls -d "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"
sf project generate manifest --name destructiveChangesManifest --metadata --array-flag "ApexClass:DLT_CaseBatch.cls-meta.xml,DLT_SubscriptionBatch.cls-meta.xml" --output-dir "/home/runner/work/SalesforceDevOpsPresentation/SalesforceDevOpsPresentation"


echo "LS AFTER"
ls
echo "********"
echo "********"
echo "********"
#sfdx force:source:deploy --manifest destructiveChangesManifest.xml -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN

































echo -e "\n\n\n--- Step 3. Logic execution to define the list of files to be deployed to the Salesforce org ---\n"
case $TARGET_BRANCH_NAME in
    "dev")
        echo -e "Find the difference between organizations\n"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo "Diff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "qa")
        echo -e "Find the difference between organizations\n"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo "Diff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "staging")
        echo -e "Find the difference between organizations\n"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo "Diff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "uat")
        echo -e "Find the difference between organizations\n"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo "Diff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "prod")
        echo -e "Find the difference between organizations\n"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo "Diff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    *)
        echo "Not valid"
        ;;
esac

echo -e "\nStep 3 execution result"
echo "Files to deploy"
echo $FILES_TO_DEPLOY
echo -e "\n--- Step 3 execution is finished ---"




echo -e "\n\n\nStep 4. Logic execution to define the list of apex tests to be executed during deployment to the Salesforce org\n"
cd force-app/main/default/classes/tests

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


echo -e "Step 4 execution result\n"
echo "LIST_OF_FILES_TO_TEST"
echo $LIST_OF_FILES_TO_TEST_TRUNC
echo -e "\n--- Step 4 execution is finished ---"




echo -e "\n\n\n--- Step 5. Deploy data to the target Salesforce org ----"
cd /home/runner/work/presentation/presentation


case $TARGET_BRANCH_NAME in
    "dev")
        echo "--- PLACEHOLDER ---.Deployment to DEV SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "qa")
        #echo "--- PLACEHOLDER ---.Deployment to QA SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "staging")
        echo "--- PLACEHOLDER ---.Deployment to STAGING SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "uat")
        echo "--- PLACEHOLDER ---.Deployment to UAT SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "prod")
        echo "--- PLACEHOLDER ---.Deployment to PROD SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    *)
        echo "Not valid"
        ;;
esac
echo "--- Step 5 execution is finished ---"