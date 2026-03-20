# Harpoon Your Tmux

`harpooning-tmux` is re-invention of ThePrimeagen's Harpoon for tmux

## What it does

- Search: You can fuzzy find all sessions with fzf
- Store: You can select certain session to `harpoon-list.txt`
- Navigate: You can move to n-th session from `harpoon-list.txt` with key bind

## Why new harpoon for tmux when `tmux-sessionizer` exists?

- `tmux-sessionizer` is mainly for creating new session after fuzzy finding projects
- hapoon-like navigation is also possible, but it is done by vim-script, which cannot be executed outside of vim
- Instead, I want to open sessions that I want to keep I on, but focus on small amount of it at a time
