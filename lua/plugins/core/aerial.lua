-- aerial.nvim
--
-- aerial.nvim is a Neovim plugin providing a code outline window for skimming and quick navigation. It comes with a lot
-- of flexibility and modularity, providing additional features like a navigation window or bread-crumbs component for
-- Lualine's statusline, for instance.

return {
  "stevearc/aerial.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>va", function() require("aerial").toggle() end, desc = "[V]iew: [A]erial outline" },
    { "<leader>a", function() require("aerial").nav_toggle() end, desc = "[A]erial navigation" },
    { "<leader>fa", function() require("telescope").extensions.aerial.aerial() end, desc = "[F]ind: [A]erial symbols" },
  },
  opts = {
    backends = {
      -- By default, let's only use specialized sources and Treesitter (LSPs can be a lot slower)
      _ = { "markdown", "asciidoc", "man", "treesitter" },
      json = { "lsp" }, -- In JSON, Treesitter is not great, LSP is actually better
    },
    layout = {
      width = 0.3,
      default_direction = "right",
      resize_to_content = false,
    },
    -- `filter_kind` can be a list (or mapping from filetype to list) of the following values (the symbol for each item
    -- is provided for reference):
    -- "Array", -- "󱡠 "
    -- "Boolean", -- "󰨙 "
    -- "Class", -- "󰆧 "
    -- "Constant", -- "󰏿 "
    -- "Constructor", -- " "
    -- "Enum", -- " "
    -- "EnumMember", -- " "
    -- "Event", -- " "
    -- "Field", -- " "
    -- "File", -- "󰈙 "
    -- "Function", -- "󰊕 "
    -- "Interface", -- " "
    -- "Key", -- "󰌋 "
    -- "Method", -- "󰊕 "
    -- "Module", -- " "
    -- "Namespace", -- "󰦮 "
    -- "Null", -- "󰟢 "
    -- "Number", -- "󰎠 "
    -- "Object", -- " "
    -- "Operator", -- "󰆕 "
    -- "Package", -- " "
    -- "Property", -- " "
    -- "String", -- " "
    -- "Struct", -- "󰆼 "
    -- "TypeParameter", -- "󰗴 "
    -- "Variable", -- "󰀫 "
    filter_kind = {
      -- Add "Array" for JSON
      json = { "Array", "Class", "Constructor", "Enum", "Function", "Interface", "Module", "Method", "Struct" },
    },
    autojump = true, -- Follow the Aerial window with the code
    on_attach = function(bufnr)
      local ts_keymap = require("plugins.core.nvim-treesitter-textobjects.keymap")
      ts_keymap.set_move_pair(
        "a",
        function() vim.cmd("AerialNext") end,
        function() vim.cmd("AerialPrev") end,
        "Aerial symbol",
        { buffer = bufnr }
      )
    end,
    show_guides = true, -- Show indentation guides in the Aerial window
    nav = {
      win_opts = { winblend = 0 }, -- Fix background color
      keymaps = { -- Add some keymaps to the navigation window
        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",
      },
    },
  },
}
