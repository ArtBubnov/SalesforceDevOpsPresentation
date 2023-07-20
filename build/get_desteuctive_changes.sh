GET_DESTRUCTIVE_DIFF=$(git diff --name-only --diff-filter=D qa force-app/main/default)

echo $GET_DESTRUCTIVE_DIFF