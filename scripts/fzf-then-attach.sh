#!/bin/bash
set -euo pipefail

# TODO: if no tmux, popup message
# TODO: if no fzf, popup message

SEARCH_PATHS=(
    "$HOME/.config/nvim:1"
    "$HOME/custom-tmux-plugins/:2"
    "$HOME/custom-nvim-plugins/:2"
    "$HOME/:1"
    "$HOME/qmk_firmware/keyboards/keebio/nyquist/:1"
    "$HOME/Desktop/SRC/OZ_CODING_SCHOOL/:3"
    "$HOME/Desktop/SRC/DRAGON_WARRIOR/:3"
)

find_git_dirs() {
    # `SEARCH_PATHS[@]`: Access all elements of the array
    for entry in "${SEARCH_PATHS[@]}"; do
        # `%`: Remove shortest match from END
        # `:*`: Pattern: colon followed by anything
        # `path="${entry%:*}"`: in entry, remove nearest `:*` at the end
        # Example: "/home/:4" -> "/home/"
        path="${entry%:*}"
        # `#`: removes a pattern from the beginning (left side)
        depth="${entry#*:}"
        # | Flag | Checks if... |
        # |------|--------------|
        # | -e | File/directory exists (any type) |
        # | -f | Exists and is a regular file |
        # | -d | Exists and is a directory |
        # | -L | Exists and is a symbolic link |
        # | -r | Exists and is readable |
        # | -w | Exists and is writable |
        # | -x | Exists and is executable |
        # | -s | Exists and has size > 0 (not empty) |
        [[ -d "$path" ]] || continue # if this is not valid directory, read the next line (do nothing)
        # echo $depth
        # [[ "$depth" =~ ^[0~9]+$ ]] || echo wrong depth

        # -type d: directory
        # -prune: ignore all children
        # 2>/dev/null: if error code 2(no such directory), move print to blackhole
        # sed: apply this edition
        # `s|/\.git$||`: replace .git to empty string
        # find "$path" -mindepth 1 -maxdepth "$depth" -type d -name ".git" -prune 2>/dev/null | sed 's|/\.git$||'
        find "$path" -mindepth 1 -maxdepth "$depth" -type d -name ".git" -print -prune 2>/dev/null | sed 's|/\.git$||'
    done
}

selected=$(find_git_dirs | sort -u | fzf)

[[ -n "$selected" ]] || exit 0

# Create/switch tmux session
session_name=$(basename "$selected" | tr . _)
if ! tmux has-session -t="$session_name" 2>/dev/null; then
   tmux new-session -ds "$session_name" -c "$selected"
fi
tmux switch-client -t "$session_name"
