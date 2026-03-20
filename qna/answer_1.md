# MVP of MVP for harpooning-tmux

Your MVP of MVP should be: **Switch to a session from a simple list using fzf**

## Why this is the right starting point

1. You already have the floating popup showing session list
2. Adding fzf selection is minimal additional work
3. This proves the core value: quickly jump to a session

## Implementation

Modify `scripts/index.sh`:

```bash
#!/usr/bin/env bash
# -e: error exit, Script exits immediately if any command exits with non-zero status
# -u: no unset, Treats unset variables as an error and exits
# -o pipefail, Pipeline exit status = last non-zero status (or 0 if all succeeded). without it, it fails silently
set -euo pipefail

# Get selected session via fzf
session=$(tmux list-sessions -F "#{session_name}" | fzf)

# Switch to selected session if one was chosen
# Breakdown
# `[ ... ]`: test command, works as if statement
# `-n`: return true for truthy, false for falsy
[ -n "$session" ] && tmux switch-client -t "$session"
```

## What this gives you

- Press keybinding (prefix + j)
- Popup appears with session list
- Use fuzzy search to find session
- Press Enter to switch, ESC to cancel

## Next steps (after MVP works)

1. **Harpoon list persistence**: Save selected sessions to a file (`~/.tmux-harpoon`)
2. **Add to harpoon**: Keybinding to add current session to the list
3. **Numbered switching**: `prefix + 1-9` to switch to nth harpooned session
4. **Nvim-style editing**: Open harpoon list in nvim buffer for reordering/deletion

Start with the fzf selection. Once that works, you'll have a foundation to build on.
