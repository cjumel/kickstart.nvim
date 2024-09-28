-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible.

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>r",
      function() require("plugins.core.grug-far.actions").grug_far() end,
      mode = { "n", "v" },
      desc = "[R]eplace",
    },
  },
  opts = {
    keymaps = {
      replace = { n = "<CR>" },
      close = { n = "q" },
      openLocation = { n = "<Tab>" }, -- Like gotoLocation but don't move the cursor
      gotoLocation = false, -- { n = "<CR>" } by default, conflict with the replace keymap
    },
  },
}
