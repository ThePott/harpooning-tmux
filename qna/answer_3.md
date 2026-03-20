# Answer: Vim-editable floating rectangle in tmux

## Solution: Use `tmux display-popup` with a temporary file + vim/nvim

The approach is:
1. Write session list to a temp file
2. Open that file in vim/nvim inside a tmux popup
3. User edits with full vim motions
4. On save & exit, read the file and create keybindings

## Implementation

```bash
#!/bin/bash
set -euo pipefail

HARPOON_FILE="$HOME/.config/harpooning-tmux/sessions.txt"

# Ensure directory exists
mkdir -p "$(dirname "$HARPOON_FILE")"

# Populate with current sessions if file doesn't exist
if [ ! -f "$HARPOON_FILE" ]; then
    tmux list-sessions -F "#{session_name}" > "$HARPOON_FILE"
fi

# Open in vim inside a popup (user can edit with full vim motions)
tmux display-popup -w 75% -h 75% -E "nvim $HARPOON_FILE"

# After exit, read lines and bind keys
# Line 0 -> prefix h 0
# Line 1 -> prefix h 1
# etc.
```

## Creating keybindings from the file

```bash
bind_sessions() {
    local line_num=0
    while IFS= read -r session_name; do
        if [ -n "$session_name" ]; then
            tmux bind-key -T harpooning "$line_num" switch-client -t "$session_name"
            ((line_num++))
        fi
    done < "$HARPOON_FILE"
}

# Set up the key table: prefix h -> enters harpooning table
tmux bind-key -T prefix h switch-client -T harpooning

bind_sessions
```

## Full workflow

1. User presses `prefix + h` -> enters harpooning key table
2. User presses `e` -> opens vim popup to edit session list
3. User presses `0-9` -> switches to that session

## Alternative: Use `vipe` (moreutils)

If you have `moreutils` installed:

```bash
session=$(tmux list-sessions -F "#{session_name}" | vipe | head -1)
```

`vipe` opens stdin in your `$EDITOR`, then outputs the result to stdout.

## Key points

- `tmux display-popup -E` closes popup when command exits
- vim/nvim inside popup gives full vim motions
- Persist the list to a file so edits are saved between sessions
- Use tmux key tables for the `prefix h 0`, `prefix h 1` pattern
