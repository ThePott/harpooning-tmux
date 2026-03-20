# Answer: Checking for duplicates in a file

## Simplest solution: Use `grep` (no arrays needed)

You don't need to parse the file into an array. Just use `grep` to check if the line already exists:

```bash
#!/bin/bash
set -euo pipefail

SESSION="$(tmux display-message -p '#S')"
HARPOON_LIST="$HOME/.config/harpooning-tmux/harpoon-list.txt"

# Ensure file exists
mkdir -p "$(dirname "$HARPOON_LIST")"
touch "$HARPOON_LIST"

# Check if session already exists in the file
if ! grep -qxF "$SESSION" "$HARPOON_LIST"; then
    echo "$SESSION" >> "$HARPOON_LIST"
fi
```

### `grep` flags explained:
- `-q`: quiet mode (no output, just exit code)
- `-x`: match whole line exactly (not partial match)
- `-F`: treat pattern as fixed string (not regex)

### How it works:
- `grep -qxF "$SESSION" "$HARPOON_LIST"` returns exit code 0 if found, 1 if not found
- `if ! grep ...` means "if NOT found, then append"

---

## Alternative: Parse file into array

If you really want an array approach:

```bash
# Read file into array (one line per element)
mapfile -t sessions < "$HARPOON_LIST"

# Check if session exists in array
found=false
for s in "${sessions[@]}"; do
    if [ "$s" = "$SESSION" ]; then
        found=true
        break
    fi
done

if [ "$found" = false ]; then
    echo "$SESSION" >> "$HARPOON_LIST"
fi
```

---

## My opinion on ThePrimeagen's advice

He's right in general, but this case is fine in bash. Here's my take:

**Bash is fine when:**
- Simple line-by-line text processing
- Glue code between unix tools
- File/process manipulation
- The logic is straightforward (like checking duplicates)

**Switch to a real language when:**
- Complex data structures (nested arrays, hashmaps with complex values)
- Heavy string manipulation or parsing
- Error handling needs to be robust
- Business logic gets complicated
- You need to maintain it long-term

For your use case (checking if a session name exists in a list), **bash + grep is perfect**. It's a one-liner and uses unix tools as intended. No need for Python/Ruby/etc.

The `grep -qxF` approach is:
- Simpler than arrays
- More performant (grep is optimized in C)
- Idiomatic unix style
