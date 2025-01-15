-- grug-far.nvim
--
-- grug-far.nvim is a find and replace plugin for Neovim. It provides a very simple interface using the full power
-- of ripgrep, while trying to be as user-friendly as possible, making it easier and more powerful to use than Neovim
-- builtin features, while not replacing them altogether. For instance, for range substitution, Neovim's search and
-- replace remains effective, even more when combined with a plugin like substitute.nvim.

return {
  "MagicDuck/grug-far.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>r", function() require("grug-far").open() end, desc = "[R]eplace" },
    { "<leader>r", function() require("grug-far").with_visual_selection() end, mode = { "v" }, desc = "[R]eplace" },
    {
      "<leader>R",
      function() require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } }) end,
      desc = "[R]eplace in buffer",
    },
    {
      "<leader>R",
      function() require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } }) end,
      mode = { "v" },
      desc = "[R]eplace in buffer",
    },
  },
  opts = {
    keymaps = {
      replace = { n = "<CR>" },
      close = { n = "q" },
      openLocation = { n = "<Tab>" },
      openNextLocation = { n = "," },
      openPrevLocation = { n = ";" },
      gotoLocation = false, -- Conflict with the custom replace keymap
      previewLocation = { n = "K" },
    },
  },
}
