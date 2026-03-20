# AGENTS.md - Guidelines for AI Coding Agents

## Project Overview

**harpooning-tmux** is a tmux plugin for quick session management, inspired by the "harpoon" paradigm.

- **Language**: Bash (Shell scripting)
- **Platform**: tmux Plugin Manager (TPM) compatible

## Project Structure

```
harpooning-tmux/
├── harpooning.tmux      # Main plugin entry point (required by TPM)
├── scripts/
│   └── index.sh         # Core functionality scripts
└── AGENTS.md            # This file
```

## Build / Lint / Test Commands

### No Build Required

This is a pure Bash project. No compilation or build step is needed.

### Manual Testing

```bash
# Reload tmux configuration to test changes
tmux source-file ~/.tmux.conf

# Test the key binding manually: prefix + j
```

### Linting (Optional)

```bash
# Install shellcheck for Bash linting
brew install shellcheck  # macOS

# Run shellcheck on all scripts
shellcheck harpooning.tmux scripts/*.sh

# Run shellcheck on a single file
shellcheck scripts/index.sh
```

## Code Style Guidelines

### Shebang and Strict Mode

```bash
#!/usr/bin/env bash
set -euo pipefail
```

### Variable Naming

- **Constants/Globals**: `UPPER_SNAKE_CASE`
- **Local variables**: `lower_snake_case`

```bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
local session_name="my-session"
```

### Quoting

Always quote variables to prevent word splitting:

```bash
echo "$CURRENT_DIR"  # Good
echo $CURRENT_DIR    # Bad
```

### Functions

```bash
get_session_list() {
    local sessions
    sessions=$(tmux list-sessions -F "#{session_name}")
    echo "$sessions"
}
```

### Comments

- Use `#` for inline comments
- Add brief description at top of each script
- Comment complex logic, prefer self-documenting code

### Indentation

Use 4 spaces for indentation (no tabs).

### Script Organization

1. Shebang line
2. Strict mode settings
3. Constants/global variables
4. Helper functions
5. Main logic

```bash
#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

show_sessions() {
    tmux list-sessions -F "#{session_name}"
}

main() {
    show_sessions
}

main "$@"
```

## tmux Plugin Conventions

### Key Files

- Main entry point: `<plugin-name>.tmux` (required by TPM)
- Script files: `lower_snake_case.sh` in `scripts/`

### Common tmux Commands

```bash
# Key bindings
tmux bind-key -T prefix "j" run-shell "bash $CURRENT_DIR/scripts/index.sh"

# Popups
tmux display-popup -w 75% -h 75% -E "command"

# Session operations
tmux list-sessions -F "#{session_name}"
tmux switch-client -t "$session_name"
```

### User-Configurable Options

```bash
default_key="j"
user_key=$(tmux show-option -gqv "@harpooning-key")
key="${user_key:-$default_key}"
tmux bind-key -T prefix "$key" run-shell "bash $CURRENT_DIR/scripts/index.sh"
```

## Common Patterns

### Getting Plugin Directory

```bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
```

### Interactive Selection with fzf

```bash
session=$(tmux list-sessions -F "#{session_name}" | fzf --prompt="Switch to: ")
[ -n "$session" ] && tmux switch-client -t "$session"
```

## Dependencies

- **Required**: tmux, bash
- **Optional**: fzf (for interactive selection), TPM (for easy installation)

## Debugging

```bash
# Write to log file
echo "Debug: variable=$variable" >> /tmp/harpooning-debug.log

# Quick feedback via tmux
tmux display-message "Debug: something happened"
```

## Adding New Features

1. Create new scripts in `scripts/` directory
2. Add key bindings in `harpooning.tmux`
3. Follow coding style guidelines above
4. Test manually by reloading tmux config
5. Update documentation if adding user-facing features

## question.md / answer.md

When working with `qna/**/question_N.md` and `qna/**/answer_N.md`:

- **Only edit `answer_N.md`** — never modify `question_N.md`
- Read the question, then write your answer in the answer file
