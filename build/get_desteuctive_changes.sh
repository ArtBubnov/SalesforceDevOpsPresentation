echo -e "--- Get destructive changes script executions start ---\n\n\n"


echo -e "--- Step 1. Define destructive changes ---\n"

DIFF_BRANCH="origin/qa"
mapfile -t files_array < <( git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default )


COUNT=0
ARRAY_LEN=${#files_array[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)
SF_COMMAND_META_STRING=""

while [ $COUNT -le $LOOP_LEN ]
do
    CURRENT_ARRAY_NODE=${files_array[$COUNT]}
    SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" '    
#    SFDX_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--sourcepath "'"'${CURRENT_ARRAY_NODE}'" '
    COUNT=$(( $COUNT +1))

done

echo "ENV_DESTRUCTIVE_DIFF_SF=$SF_COMMAND_META_STRING" >> "$GITHUB_ENV"
#echo "ENV_DESTRUCTIVE_DIFF_SFDX=$SFDX_COMMAND_META_STRING" >> "$GITHUB_ENV"


echo -e "\nStep 1 execution result"
echo "destructive changes list is: "
echo $SF_COMMAND_META_STRING
#echo "------------"
#echo "------------"
#echo "------------"
#echo "------------"
#echo "------------"
#echo $SFDX_COMMAND_META_STRING