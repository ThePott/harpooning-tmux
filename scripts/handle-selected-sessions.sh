#!/bin/bash
set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# NOTE: '' - just string. literal string << NOT highlight keywords 
# NOTE: "" - can include variable << highlight keywords
tmux display-popup -w 50% -h 50% -E "cd $CURRENT_DIR && vim ./harpoon-list.txt" 


