-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible.

return {
  "MagicDuck/grug-far.nvim",
  keys = function()
    local grug_far = require("grug-far")
    return {
      {
        "<leader>rr",
        function() grug_far.grug_far({}) end,
        desc = "[R]eplace: [R]eplace",
      },
      {
        "<leader>rr",
        function() grug_far.with_visual_selection({}) end,
        mode = "v",
        desc = "[R]eplace: [R]eplace selection",
      },
      {
        "<leader>rc",
        function() grug_far.grug_far({ prefills = { paths = vim.fn.expand("%") } }) end,
        desc = "[R]eplace: in [C]urrent buffer",
      },
      {
        "<leader>rc",
        function() grug_far.with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end,
        mode = "v",
        desc = "[R]eplace: selection in [C]urrent buffer",
      },
    }
  end,
  opts = {},
}
