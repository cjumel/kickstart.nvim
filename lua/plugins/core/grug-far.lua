-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible, making it easier and more powerful to use than Neovim
-- builtin features, while not replacing them altogether. For instance, for range substitution, Neovim's search and
-- replace remains effective, even more when combined with a plugin like substitute.nvim.

return {
  "MagicDuck/grug-far.nvim",
  keys = function()
    local actions = require("plugins.core.grug-far.actions")
    return {
      { "<leader>rr", actions.grug_far, mode = { "n", "v" }, desc = "[R]eplace: unrestricted" },
      { "<leader>rb", actions.grug_far_buffer, mode = { "n", "v" }, desc = "[R]eplace: in [B]uffer" },
      { "<leader>rf", actions.grug_far_filetype, mode = { "n", "v" }, desc = "[R]eplace: in [F]iletype" },
    }
  end,
  opts = {
    keymaps = {
      replace = { n = "<CR>" },
      close = { n = "q" },
      openLocation = { n = "<Tab>" }, -- Like gotoLocation but don't move the cursor
      gotoLocation = false, -- { n = "<CR>" } by default, conflict with the replace keymap
    },
  },
}
