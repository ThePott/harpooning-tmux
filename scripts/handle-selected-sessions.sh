#!/bin/bash
set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# NOTE: '' - just string. literal string << NOT highlight keywords 
# NOTE: "" - can include variable << highlight keywords
tmux display-popup -w 50% -h 50% -E "cd $CURRENT_DIR && vim ./harpoon-list.md" 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"
CHECKED_SESSIONS=$(grep -E '^- \[x\]' "$HARPOON_LIST" | sed 's/^- \[x\] //')
COUNT=$(echo "$CHECKED_SESSIONS" | grep -c .)

ADD_SESSION="$SCRIPT_DIR/handle-list/add-session.sh"
DELETE_SESSION="$SCRIPT_DIR/handle-list/delete-session.sh"

if [ $COUNT -eq 0 ]; then
    FIRST_SESSION=$(sed -n "1p" "$HARPOON_LIST" | "sed s/^- \[.*] /")
    tmux switch-client -t "$FIRST_SESSION"
    bash "$ADD_SESSION" "$FIRST_SESSION"
else
    FIRST_CHECKED_SESSION=$(grep -E '^- \[x\]' "$HARPOON_LIST" | sed 's/^- \[x\] //')
    tmux switch-client -t "$FIRST_CHECKED_SESSION"
    bash "$ADD_SESSION" "$FIRST_CHECKED_SESSION"
fi

# TODO:
# for loop each line
# check if there are mismatching actual session vs session in list
# if mismatching, delete opponent (if no actual session, remove that session from list. if not in list, then kill actual session)
