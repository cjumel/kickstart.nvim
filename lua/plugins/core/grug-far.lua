-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible, making it easier and more powerful to use than Neovim
-- builtin features, while not replacing them altogether. For instance, for range substitution, Neovim's search and
-- replace remains effective, even more when combined with a plugin like substitute.nvim.

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>rr",
      function() require("plugins.core.grug-far.actions").grug_far() end,
      mode = { "n", "v" },
      desc = "[R]eplace: unrestricted",
    },
    {
      "<leader>rb",
      function() require("plugins.core.grug-far.actions").grug_far({ current_buffer_only = true }) end,
      mode = { "n", "v" },
      desc = "[R]eplace: in [B]uffer",
    },
    {
      "<leader>rf",
      function() require("plugins.core.grug-far.actions").grug_far({ current_filetype_only = true }) end,
      mode = { "n", "v" },
      desc = "[R]eplace: in [F]iletype",
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
