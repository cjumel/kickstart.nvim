# Todo

## Known issues

- Current re-implementation doesn't support cmp_dap
- There's an issue when using a snippet like `:fire:` when completing a word with blink.cmp while in
  a choice node (e.g. `:fire: (wezterm): ...` where wezterm is completed using blink.cmp): we can't
  resume the node navigation after the blink.cmp completion
- With snacks smooth scrolling feature, blink sometimes get crazy while scrolling in suggestions
- Some snippets are not working:
  - The `.<extension>` snippet in oil buffers doesn't work
  - the `__init__.py` snippet in oil buffers doesn't work
  - The todo-keyword snippet doesn't work in python commnets (the todo-comment one is suggested instead)
