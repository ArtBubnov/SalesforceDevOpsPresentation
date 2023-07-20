DIFF_BRANCH="origin\qa"
mapfile -t files_array < <( git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default )


COUNT=0
ARRAY_LEN=${#files_array[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)
SF_COMMAND_META_STRING=""

while [ $COUNT -le $LOOP_LEN ]
do
    CURRENT_ARRAY_NODE=${files_array[$COUNT]}
    SF_COMMAND_META_STRING=${SF_COMMAND_META_STRING}"--source-dir "'"'${CURRENT_ARRAY_NODE}'" '
    COUNT=$(( $COUNT +1))

done


echo "-----------TEST--------------"
echo $SF_COMMAND_META_STRING