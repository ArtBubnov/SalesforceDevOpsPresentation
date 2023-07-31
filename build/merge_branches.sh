
echo -e "\n\n\nMerge PR\n"



#echo -e "--- Step 1. Define Salesforce deployment status ---\n"


#SALESFORCE_DEPLOYMENT_STATUS_INFO=$(sfdx force:mdapi:deploy:report --jobid "0Af5j00000TcKLhCAN" -u ${SALESFORCE_ORG_ALIAS})


#echo -e "\nStep 1 execution result:"
#echo -e "\nSalesforce deployment status is:"
#echo $SALESFORCE_DEPLOYMENT_STATUS_INFO
#echo -e "\n--- Step 1 execution is finished ---"




#echo -e "--- Step 2. Define if PR should be merged ---\n"


#$SALESFORCE_DEPLOYMENT_STATUS_SUCCESS_INFO="Succeeded Deployed"

#if [[ "$SALESFORCE_DEPLOYMENT_STATUS_INFO" == *"$SALESFORCE_DEPLOYMENT_STATUS_SUCCESS_INFO"* ]];
#then
#    echo "Due to the Salesforce deploymen has been successful"
#    echo "PR should be merget"
#    curl -L \
#      -X PUT \
#      -H "Accept: application/vnd.github+json" \
#      -H "Authorization: Bearer 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" \
#      -H "X-GitHub-Api-Version: 2022-11-28" \
#      https://api.github.com/repos/ArtBubnov/SalesforceDevOpsPresentation/pulls/${{ github.event.number }}/merge \
#      -d '{"commit_title":"Expand enum","commit_message":"Add a new value to the merge_method enum"}' 
#      echo -e "\n--- Step 2 execution is finished ---"
#else
#    echo -e "\n--- Step 2 execution is finished ---"
#    echo "Due to the Salesforce deploymen has NOT been successful"
#    echo "PR should NOT be merget"
#    echo "Script execution will be finished with 1 status code"
#    exit 1
#fi

