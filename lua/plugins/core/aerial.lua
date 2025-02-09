-- aerial.nvim
--
-- aerial.nvim provides code outline features for skimming through the code and quick navigation. It comes with a lot of
-- flexibility and modularity, along with additional features like a status bar bread-crumbs component, for instance.

return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>-", function() require("aerial").nav_toggle() end, desc = "Outline navigation" },
    { "<leader>vs", function() require("aerial").toggle() end, desc = "[V]iew: outline [S]ymbols" },
    {
      "<leader>fs",
      function() require("telescope").extensions.aerial.aerial({ prompt_title = "Find Outline Symbols" }) end,
      desc = "[F]ind: outline [S]ymbols",
    },
  },
  opts = {
    layout = { width = 0.3, default_direction = "right", resize_to_content = false },
    autojump = true,
    show_guides = true,
    nav = {
      win_opts = { winblend = 0 }, -- Better for transparent backgrounds
      keymaps = { ["q"] = "actions.close", ["<Esc>"] = "actions.close" },
    },
  },
}
