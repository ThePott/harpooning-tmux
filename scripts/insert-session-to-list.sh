#!/bin/bash
set -euo pipefail

# NO space around = for variable. if there are, it is interpreted as command
# blue color: command
SESSION="$(tmux display-message -p '#S')"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# NOTE: '' - just string. literal string << NOT highlight keywords 
# NOTE: "" - can include variable << highlight keywords
HARPOON_LIST="$CURRENT_DIR/harpoon-list.txt"

# `grep` flags explained:
# `-q`: quiet mode (no output, just exit code)
# `-x`: match whole line exactly (not partial match)
# `-F`: treat pattern as fixed string (not regex)
if ! grep -qxF "$SESSION" "$HARPOON_LIST";
then
    echo "$SESSION" >> "$HARPOON_LIST"
fi
