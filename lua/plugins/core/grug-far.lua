-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible.

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>rr",
      function() require("plugins.core.grug-far.actions").grug_far() end,
      mode = { "n", "v" },
      desc = "[R]eplace: [R]eplace",
    },
    {
      "<leader>rc",
      function() require("plugins.core.grug-far.actions").grug_far_current_buffer() end,
      mode = { "n", "v" },
      desc = "[R]eplace: in [C]urrent buffer",
    },
  },
  opts = {},
}
