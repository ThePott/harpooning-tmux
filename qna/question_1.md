# I want to create MVP for "harpoon but for tmux"

## What I want as final product

### insert to harpoon

- enter insert keymap: insert current session in harpoon

### open sessions in harpoon

- enter open n-th session keymap: bring n-th session in harpoon list to front of tmux

### harpoon list

- enter open keymap: open floating rectangle that contains session names
- I want to use nvim movement there, so maybe open nvim of some buffer and use it? (I don't know the meaning of buffer
  so I'm not sure what I'm saying)
- when I delete a line and close floating window, that session is out of harpoon and do not track anymore
- when I change the order of the line, it is applied to opening n-th session actions

## What I have done so far

- when press keymap, floating rectangle shows up
- there is session list inside of it
- it closes when I press ESC

## What I want for now: MVP of MVP

- I want to create this plugin, but step by step. So I want MVP of MVP, not full features
- tell me what that is
