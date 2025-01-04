-- aerial.nvim
--
-- aerial.nvim is a Neovim plugin providing a code outline window for skimming and quick navigation. It comes with a lot
-- of flexibility and modularity, providing additional features like a navigation window or bread-crumbs component for
-- Lualine's statusline, for instance.

return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>a", function() require("aerial").nav_toggle() end, desc = "[A]erial navigation" },
    { "<leader>va", function() require("aerial").toggle() end, desc = "[V]iew: [A]erial outline" },
    { "<leader>fa", function() require("telescope").extensions.aerial.aerial() end, desc = "[F]ind: [A]erial symbols" },
  },
  opts = {
    backends = { json = { "lsp" } }, -- In JSON, Treesitter is not great, LSP is actually better
    layout = {
      width = 0.3,
      default_direction = "right",
      resize_to_content = false,
    },
    filter_kind = {
      -- Add "Array" for JSON to make it more relevant
      json = { "Array", "Class", "Constructor", "Enum", "Function", "Interface", "Module", "Method", "Struct" },
    },
    autojump = true, -- Follow the Aerial window with the code
    show_guides = true, -- Show indentation guides in the Aerial window
    nav = {
      win_opts = { winblend = 0 }, -- Fix background color with transparent backgrounds
      keymaps = { ["q"] = "actions.close", ["<Esc>"] = "actions.close" },
    },
  },
}
