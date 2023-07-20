GET_DESTRUCTIVE_DIFF=$(git diff --name-only --diff-filter=D ${DIFF_BRANCH} force-app/main/default)
echo $GET_DESTRUCTIVE_DIFF