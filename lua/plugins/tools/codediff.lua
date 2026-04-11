return {
  "esmuellert/codediff.nvim",
  cmd = { "CodeDiff" },
  opts = {
    keymaps = {
      view = {
        toggle_explorer = "<localleader>b",
        next_hunk = "]h",
        prev_hunk = "[h",
        toggle_layout = "<localleader>l",
      },
    },
  },
}
