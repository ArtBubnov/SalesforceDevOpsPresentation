echo -e "--- Get destructive changes script executions start ---\n\n\n"


echo -e "--- Step 1. Define destructive changes ---\n"
#echo "---------TEST-----------"
#echo "Creating .key file"
#touch access_pass.key
#
#echo -e "\nAdding access data to .key file"
#echo $DEV_SALESFORCE_AUTH_GITHUB_SECRET_VALUE > access_pass.key
#SALESFORCE_ORG_ALIAS="salesforce_dev.org"

#echo -e "\nTry SF login"
#sfdx force:auth:sfdxurl:store -f "access_pass.key" -a ${SALESFORCE_ORG_ALIAS} -d
#rm access_pass.key




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