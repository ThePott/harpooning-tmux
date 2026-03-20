#!/bin/bash
set -euo pipefail

LINE_NUM="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.txt"

SESSION_NAME=$(sed -n "$((LINE_NUM + 1))p" "$HARPOON_LIST")


if [ -n "$SESSION_NAME" ];
then tmux switch-client -t "$SESSION_NAME"
else tmux display-message "No session at slot $LINE_NUM"
fi
